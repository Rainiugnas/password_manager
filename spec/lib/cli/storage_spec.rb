# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

RSpec.describe Storage do
  let(:path) { '/path' }
  let(:readable?) { true }
  let(:writeable?) { true }
  let(:data) { 'data' }
  let(:storage) { Storage.new path }

  before(:each) do
    allow(File).to receive(:read).with(path).and_return data
    allow(File).to receive(:readable?).and_return readable?
    allow(File).to receive(:writeable?).and_return writeable?
  end

  describe '.new' do
    context 'with readable and writeable file' do
      it 'should success and set the storage data' do
        expect(storage.success).to be_truthy
        expect(storage.data).to eq data
      end
    end

    context 'when file is not readable' do
      let(:readable?) { false }

      it 'should not success and set an error' do
        expect(storage.success).to be_falsy
        expect(storage.error).to eq 'Error: the given file have not read and write right'
      end
    end

    context 'when file is not writeable' do
      let(:writeable?) { false }

      it 'should not success and set an error' do
        expect(storage.success).to be_falsy
        expect(storage.error).to eq 'Error: the given file have not read and write right'
      end
    end
  end

  describe 'reload' do
    it 'should read the file data and set the value' do
      old_data = storage.data

      expect(File).to receive(:read).with(path).and_return 'new data'
      storage.reload

      expect(storage.data).not_to eq old_data
      expect(storage.data).to eq 'new data'
    end
  end

  describe 'save!' do
    it 'should write the storage data into the file' do
      expect(File).to receive(:write).with(path, data)

      storage.save!
    end
  end
end
