# frozen_string_literal: true

RSpec.describe Base64 do
  let(:crypter) { PasswordManager::Crypter::Base64.new }
  let(:data) { 'data' }
  let(:encrypted_data) { crypter.encrypt data }

  describe '#encrypt' do
    it 'should encrypt the given data' do
      expect(encrypted_data).not_to eq data
    end
  end

  describe '#decrypt' do
    it 'should be able to decrypt encrypted data' do
      expect(crypter.decrypt encrypted_data).to eq data
    end
  end
end
