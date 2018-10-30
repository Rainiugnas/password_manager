# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

RSpec.describe CliFileCrypter do
  describe '.interupt!' do
    it 'should raise an password manager exception with the given message' do
      expect { described_class.interupt! 'message' }.to raise_exception 'message'
    end
  end

  describe '.run' do
    let(:crypter1) { Aes.new password }
    let(:crypter2) { PasswordManager::Crypter::Base64.new }
    let(:crypters) { [crypter1, crypter2] }
    let(:converter) { Converter.from_array sites, crypters }

    let(:raw_file) { 'file data' }
    let(:crypt_file) { 'base64:aes:file data' }
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

      allow(Aes).to receive(:new).with(password).and_return DummyCrypter.new 'aes'
      allow(PasswordManager::Crypter::Base64).to receive(:new).and_return DummyCrypter.new 'base64'

      dummy_password = double(value: password, success: password_success?, error: password_error)
      allow(PasswordConfirmation).to receive(:new).and_return dummy_password

      stub_const 'ARGV', %w(rspec).concat(argv)
    end

    describe 'storage error' do
      let(:readable?) { false }
      let(:argv) { %w(-e -f).push path }

      it 'should print the error' do
        message = 'Error: the given file have not read and write right'
        expect { described_class.run }.to output(message).to_stdout
      end
    end

    describe 'option error' do
      context 'with invalid action number' do
        let(:argv) { %w(-e -d -f).push path }

        it 'should print the error' do
          message = <<~MSG
            invalid option: you must set one (no more) of the following options: --encrypt, --decrypt, --show, --add, --tmp and --list
          MSG

          expect { described_class.run }.to output(message).to_stdout
        end
      end

      context 'with other action than encrypt or decrypt' do
        let(:argv) { %w(-l -f).push path }

        it 'should print the error' do
          msg = 'Option must be file and either encrypt or decrypt. Other option are not suported.'

          expect { described_class.run }.to output(msg).to_stdout
        end
      end
    end

    describe 'password error' do
      let(:argv) { %w(-e -f).push path }
      let(:password_success?) { false }

      it 'should print the error' do
        expect { described_class.run }.to output(password_error).to_stdout
      end
    end

    describe 'encrypt' do
      let(:argv) { %w(-e -f).push path }
      let(:file) { raw_file }

      it 'should encrypt the file' do
        expect(File).to receive(:write).with path, crypt_file

        described_class.run
      end
    end

    describe 'decrypt' do
      let(:argv) { %w(-d -f).push path }
      let(:file) { crypt_file }

      it 'should decrypt the file' do
        expect(File).to receive(:write).with path, raw_file

        described_class.run
      end
    end
  end
end
