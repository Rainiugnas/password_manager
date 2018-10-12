# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require 'base64'

module PasswordManager
  RSpec.describe Crypter do
    let(:password) { 'password' }
    let(:crypter) { Crypter.new password }
    let(:other) { Crypter.new 'other' }
    let(:data) { 'data' }
    let(:encrypted_data) { crypter.encrypt data }

    describe '.encrypt' do
      it 'should encrypt the data' do
        expect(encrypted_data).not_to eq data
      end

      it 'should change the result if the password is not the same' do
        expect(encrypted_data).not_to eq other.encrypt data
      end
    end

    describe '.decrypt' do
      context 'when the password is the same' do
        it 'should retrieve the original data' do
          expect(crypter.decrypt encrypted_data).to eq data
        end
      end

      context 'when the password is not the same' do
        it 'should raise exception' do
          expect { other.decrypt encrypted_data }.to raise_exception OpenSSL::Cipher::CipherError
        end
      end
    end

    describe 'encrypt_base64' do
      it 'should return the encryption into base 64 format' do
        base64_data = crypter.encrypt_base64 data

        expect(Base64.decode64 base64_data).to eq encrypted_data
      end
    end

    describe 'decrypt_base64' do
      it 'should decrypt the base 64 formated encryption' do
        base64_encryption = Base64.encode64 encrypted_data

        expect(crypter.decrypt_base64 base64_encryption).to eq data
      end
    end
  end
end
