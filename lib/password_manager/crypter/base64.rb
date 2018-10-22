# frozen_string_literal: true

module PasswordManager
  module Crypter
    # Handle Base64 format
    class Base64
      # @param [String] data Data to encrypt
      # @return [String] the Base64 encrypted data
      def encrypt(data) ::Base64.encode64 data end

      # @param [String] data Base64 data to decrypt
      # @return [String] Result of the decryption
      def decrypt(data)
        ::Base64.decode64 data
      end
    end
  end
end
