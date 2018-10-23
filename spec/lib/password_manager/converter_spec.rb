# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require 'json'

RSpec.describe Converter do
  let(:crypter1) { DummyCrypter.new 'c1' }
  let(:crypter2) { DummyCrypter.new 'c1v2' }
  let(:crypters) { [crypter1, crypter2] }

  let(:site) { PasswordManager::Site.new 'name', 'user', 'password' }
  let(:array) { [site] }
  let(:json) { JSON.generate 'name' => { 'username' => 'user', 'password' => 'password' } }
  let(:encrypted_data) { "c1v2:c1:#{json}" }

  let(:converter) { Converter.from_array array, crypters }

  describe '.from_crypt' do
    it 'should set the converter array from the given encrypted data and crypters' do
      expect(Converter.from_crypt(encrypted_data, crypters).to_array).to match_site_array array
    end
  end

  describe '.from_json' do
    it 'should set the converter array from the given json' do
      expect(Converter.from_json(json, crypters).to_array).to match_site_array array
    end

    context 'when the given json is invalid' do
      it 'should raise an exception' do
        expect { Converter.from_json 'invalid', crypters }.to raise_exception ConverterError
      end
    end
  end

  describe '.from_array' do
    it 'should set the converter array with the given array' do
      expect(Converter.from_array(array, crypters).to_array).to eq array
    end
  end

  describe '#to_array' do
    it 'should return the given array' do
      expect(converter.to_array).to eq array
    end
  end

  describe '#to_json' do
    it 'should convert the array in json' do
      expect(converter.to_json).to eq json
    end
  end

  describe '#to_crypt' do
    it 'should encryt the array with the given encrypters' do
      expect(converter.to_crypt).to eq encrypted_data
    end
  end
end
