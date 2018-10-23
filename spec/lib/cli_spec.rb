# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

RSpec.describe Cli do
  describe '.interupt!' do
    it 'should raise an password manager exception with the given message' do
      expect { Cli.interupt! 'message' }.to raise_exception 'message'
    end
  end

  describe '.run' do
    let(:site1) { PasswordManager::Site.new '1', 'user', 'password' }
    let(:site2) { PasswordManager::Site.new '2', 'user', 'password' }
    let(:site3) { PasswordManager::Site.new '3', 'user', 'password' }
    let(:sites) { [site1, site2, site3] }
    let(:crypter1) { Aes.new password }
    let(:crypter2) { PasswordManager::Crypter::Base64.new }
    let(:crypters) { [crypter1, crypter2] }
    let(:converter) { Converter.from_array sites, crypters }

    let(:json_file) { converter.to_json }
    let(:crypt_file) { converter.to_crypt }
    let(:readable?) { true }
    let(:path) { 'file/path' }
    let(:file) { crypt_file }

    let(:password) { 'password' }
    let(:password_error) { 'invalid confirmation' }
    let(:password_success?) { true }

    before(:each) do
      allow(File).to receive(:read).with(path).and_return file
      allow(File).to receive(:readable?).and_return readable?
      allow(File).to receive(:writable?).and_return true

      dummy_password = double(value: password, success: password_success?, error: password_error)
      allow(PasswordConfirmation).to receive(:new).and_return dummy_password

      stub_const 'ARGV', %w(rspec).concat(argv)
    end

    describe 'storage error' do
      let(:readable?) { false }
      let(:argv) { %w(-e -f).push path }

      it 'should print the error' do
        expect { Cli.run }.to output('Error: the given file have not read and write right').to_stdout
      end
    end

    describe 'option error' do
      let(:argv) { %w(-e -d -f).push path }

      it 'should print the error' do
        message = <<~MSG
          invalid option: you must set one (no more) of the following options: --encode, --decode, --show, --add, --tmp and --list
        MSG

        expect { Cli.run }.to output(message).to_stdout
      end
    end

    describe 'password error' do
      let(:argv) { %w(-e -f).push path }
      let(:password_success?) { false }

      it 'should print the error' do
        expect { Cli.run }.to output(password_error).to_stdout
      end
    end

    describe 'encode' do
      let(:argv) { %w(-e -f).push path }
      let(:file) { json_file }

      it 'should encode the file' do
        expect(File).to receive(:write).with path, crypt_file

        Cli.run
      end
    end

    describe 'decode' do
      let(:argv) { %w(-d -f).push path }
      let(:file) { crypt_file }

      it 'should decode the file' do
        expect(File).to receive(:write).with path, json_file

        Cli.run
      end
    end

    describe 'list' do
      let(:argv) { %w(-l -f).push path }
      let(:file) { crypt_file }

      it 'should list the name of all the file site' do
        message = <<~MSG
          Found 3 sites names:
          1
          2
          3
        MSG
        expect { Cli.run }.to output(message).to_stdout
      end
    end

    describe 'add' do
      let(:argv) { %w(-a -f).push path }
      let(:file) { crypt_file }
      let(:new_site) { PasswordManager::Site.new '4', 'user', 'password' }

      it 'should add the new site to the file' do
        expect(Cli::Input::Site).to receive(:new).and_return new_site

        udpdated_converter = Converter.from_array(converter.to_array + [new_site], crypters)
        expect(File).to receive(:write).with(path, udpdated_converter.to_crypt)

        Cli.run
      end

      context 'when the site is invalid' do
        let(:new_site) { PasswordManager::Site.new '', 'user', 'password' }

        it 'should print the error' do
          expect(Cli::Input::Site).to receive(:new).and_return new_site
          expect { Cli.run }.to output('Error: site name must be present').to_stdout
        end
      end
    end

    describe 'show' do
      let(:argv) { %w(-s 2 -f).push path }
      let(:file) { crypt_file }

      it 'should find the site and display the data' do
        message = <<~MSG
          Data associated to 2:
          - username: user
          - password: password
        MSG
        expect { Cli.run }.to output(message).to_stdout
      end

      context 'when the site does not exist' do
        let(:argv) { %w(-s unknow -f).push path }

        it 'should print the error' do
          message = "Error: 'unknow' is not a valid site name"

          expect { Cli.run }.to output(message).to_stdout
        end
      end
    end

    describe 'tmp' do
      let(:argv) { %w(-t -f).push path }

      it 'should decode the file and after the stop re encode it' do
        expect(File).to receive(:read).with(path).and_return crypt_file
        expect(File).to receive(:write).with path, json_file

        expect(Stop).to receive(:new)

        expect(File).to receive(:read).with(path).and_return json_file
        expect(File).to receive(:write).with path, crypt_file

        Cli.run
      end
    end
  end
end
