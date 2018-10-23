# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

RSpec.describe Option do
  shared_examples :set_option do |argv_options, option_name, expected_value|
    context "with #{argv_options.join(' ')}" do
      let(:argv) { argv_options }

      it "should set the option #{option_name}" do
        expect(option.send option_name).to eq expected_value
      end
    end
  end

  let(:option) { Option.new }

  before :each do
    stub_const 'ARGV', %w(rspec).concat(argv)
  end

  describe 'options' do
    include_examples :set_option, %w(-f path), :file, 'path'
    include_examples :set_option, %w(--file path), :file, 'path'

    include_examples :set_option, %w(-e), :encrypt, true
    include_examples :set_option, %w(--encrypt), :encrypt, true

    include_examples :set_option, %w(-d), :decrypt, true
    include_examples :set_option, %w(--decrypt), :decrypt, true

    include_examples :set_option, %w(-s site), :show, 'site'
    include_examples :set_option, %w(--show site), :show, 'site'

    include_examples :set_option, %w(-l), :list, true
    include_examples :set_option, %w(--list), :list, true

    include_examples :set_option, %w(-a), :add, true
    include_examples :set_option, %w(--add), :add, true

    include_examples :set_option, %w(-t), :tmp, true
    include_examples :set_option, %w(--tmp), :tmp, true

    context 'without argv' do
      let(:argv) { [] }

      it 'should set the options to their default value' do
        expect(option.file).to be_nil
        expect(option.show).to be_nil
        expect(option.file).to be_falsy
        expect(option.encrypt).to be_falsy
        expect(option.decrypt).to be_falsy
        expect(option.list).to be_falsy
        expect(option.add).to be_falsy
        expect(option.tmp).to be_falsy
      end
    end
  end

  describe 'errors' do
    context 'with an unknow option' do
      let(:argv) { %w(--unknow -f path -d) }

      it 'should not success' do
        expect(option.success).to be_falsy
        expect(option.error).to match /invalid option: --unknow/
      end
    end

    context 'with --help' do
      let(:argv) { %w(--help -f path -d) }

      it 'should not success and hold the help message' do
        expect(option.success).to be_falsy
        expect(option.error).to match /Usage:/
      end
    end

    context 'without file path' do
      let(:argv) { %w(-d) }

      it 'should not success' do
        expect(option.success).to be_falsy
        expect(option.error).to eq 'invalid option: file (option -f / --file) must be provided'
      end
    end

    context 'without any actions option' do
      let(:argv) { %w(-f path) }

      it 'should not success' do
        expect(option.success).to be_falsy
        expect(option.error).to eq <<~MSG
          invalid option: you must set one (no more) of the following options: --encrypt, --decrypt, --show, --add, --tmp and --list
        MSG
      end
    end

    context 'with more than one action options' do
      let(:argv) { %w(-f path -d -t) }

      it 'should not success' do
        expect(option.success).to be_falsy
        expect(option.error).to eq <<~MSG
          invalid option: you must set one (no more) of the following options: --encrypt, --decrypt, --show, --add, --tmp and --list
        MSG
      end
    end
  end

  describe 'success' do
    context 'with valid option' do
      let(:argv) { %w(-f path -t) }

      it 'should success' do
        expect(option.success).to be_truthy
      end
    end
  end
end
