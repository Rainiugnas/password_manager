# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength
# rubocop:disable Metrics/BlockLength

module PasswordManager
  RSpec.describe Options do
    before :each do
      stub_const 'ARGV', %w(rspec -f file_path).concat(options)
    end

    describe 'unknow option' do
      let(:options) { %w(--unknow) }

      it 'should print invalid option' do
        expect { Options.instance }.to output('invalid option: --unknow').to_stdout
      end
    end

    describe 'help' do
      let(:options) { %w(--help) }

      it 'should display the help message' do
        expect { Options.instance }.to output(/Usage:/).to_stdout
      end
    end

    describe 'file path' do
      shared_examples :new_path do
        it 'should set the file path with file option' do
          expect(Options.file).to eq 'new_path'
        end
      end

      let(:options) { [] }

      it 'should be required' do
        stub_const 'ARGV', %w(rspec).concat(options)

        message = 'Error: file (option -f / --file) must be provided'
        expect { Options.instance }.to output(message).to_stdout
      end

      context 'with -f' do
        let(:options) { %w(-f new_path) }

        include_examples :new_path
      end

      context 'with --file' do
        let(:options) { %w(--file new_path) }

        include_examples :new_path
      end
    end

    describe 'encode' do
      shared_examples :true_encode do
        it 'should set the encode option to true' do
          expect(Options.encode).to be_truthy
        end
      end

      let(:options) { [] }

      it 'should be set to false by default' do
        expect(Options.encode).to be_falsy
      end

      context 'with -E' do
        let(:options) { %w(-E) }

        include_examples :true_encode
      end

      context 'with --encode' do
        let(:options) { %w(--encode) }

        include_examples :true_encode
      end
    end

    describe 'decode' do
      shared_examples :true_decode do
        it 'should set the decode option to true' do
          expect(Options.decode).to be_truthy
        end
      end

      let(:options) { [] }

      it 'should be set to false by default' do
        expect(Options.decode).to be_falsy
      end

      context 'with -D' do
        let(:options) { %w(-D) }

        include_examples :true_decode
      end

      context 'with --decode' do
        let(:options) { %w(--decode) }

        include_examples :true_decode
      end
    end

    describe 'show site name' do
      shared_examples :site_name_show do
        it 'should set the encode option to true' do
          expect(Options.show).to eq 'site_name'
        end
      end

      let(:options) { [] }

      it 'should be false by default' do
        expect(Options.show).to be_falsy
      end

      context 'with -S' do
        let(:options) { %w(-S site_name) }

        include_examples :site_name_show
      end

      context 'with --site' do
        let(:options) { %w(--show site_name) }

        include_examples :site_name_show
      end
    end

    describe 'add' do
      shared_examples :true_add do
        it 'should set the add option to true' do
          expect(Options.add).to be_truthy
        end
      end

      let(:options) { [] }

      it 'should be set to false by default' do
        expect(Options.add).to be_falsy
      end

      context 'with -A' do
        let(:options) { %w(-A) }

        include_examples :true_add
      end

      context 'with --add' do
        let(:options) { %w(--add) }

        include_examples :true_add
      end
    end

    describe 'list' do
      shared_examples :true_list do
        it 'should set the list option to true' do
          expect(Options.list).to be_truthy
        end
      end

      let(:options) { [] }

      it 'should be set to false by default' do
        expect(Options.list).to be_falsy
      end

      context 'with -L' do
        let(:options) { %w(-L) }

        include_examples :true_list
      end

      context 'with --list' do
        let(:options) { %w(--list) }

        include_examples :true_list
      end
    end

    describe 'tmp' do
      shared_examples :true_tmp do
        it 'should set the tmp option to true' do
          expect(Options.tmp).to be_truthy
        end
      end

      let(:options) { [] }

      it 'should be set to false by default' do
        expect(Options.tmp).to be_falsy
      end

      context 'with -T' do
        let(:options) { %w(-T) }

        include_examples :true_tmp
      end

      context 'with --tmp' do
        let(:options) { %w(--tmp) }

        include_examples :true_tmp
      end
    end
  end
end
