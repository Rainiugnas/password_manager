# frozen_string_literal: true

RSpec.describe Aes do
  let(:aes_1) { Aes.new '1' }
  let(:aes_2) { Aes.new '2' }
  let(:data) { 'data' }
  let(:encrypted_data) { aes_1.encrypt data }

  describe 'interface' do
    it 'should implement crypter interface' do
      expect(aes_1).to be_crypter
    end
  end

  describe '#encrypt' do
    it 'should encrypt the given data' do
      expect(encrypted_data).not_to eq data
    end

    it 'should use the given password to encrypt the data' do
      expect(encrypted_data).not_to eq aes_2.encrypt data
    end
  end

  describe '#decrypt' do
    context 'when password is the same than encrypt' do
      it 'should be able to decrypt encrypted data' do
        expect(aes_1.decrypt encrypted_data).to eq data
      end
    end

    context 'when password is not the same than encrypt' do
      it 'should raise an exception' do
        expect { aes_2.decrypt encrypted_data }.to raise_exception DecryptError
      end
    end
  end
end
