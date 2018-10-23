# frozen_string_literal: true

require 'openssl'
require 'digest/sha2'

module PasswordManager
  module Crypter
    # Handle AES format
    class Aes
      # Set the password to salt encrypt / decrypt
      # @param [String] password
      def initialize password
        @cipher = OpenSSL::Cipher.new 'AES-256-CBC'
        @password = password
      end

      # @param [String] data Data to encrypt
      # @return [String] the AES encrypted data
      def encrypt(data) use_cipher_to :encrypt, data end

      # @param [String] data AES data to decrypt
      # @return [String] Result of the decryption
      # @raise [DecryptError] When the password is invalid
      def decrypt(data)
        use_cipher_to :decrypt, data
      rescue OpenSSL::Cipher::CipherError
        raise DecryptError,
              'Error: the password use to encrypt is not the same than the decrypt password'
      end

      private

      def iv() @iv ||= key[0..15] end

      def key
        @key ||= begin
          digest = Digest::SHA256.new
          digest.update @password
          digest.digest
        end
      end

      # Dry the cipher usage for both decrypt and encrypt
      def use_cipher_to action, data
        @cipher.reset
        @cipher.send action
        @cipher.key = key
        @cipher.iv = iv
        @cipher.update(data) + @cipher.final
      end
    end
  end
end
