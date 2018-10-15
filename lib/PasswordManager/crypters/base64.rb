# frozen_string_literal: true

module PasswordManager
  module Crypters
    class Base64
      def encrypt(data) ::Base64.encode64 data end

      def decrypt(data)
        ::Base64.decode64 data
      end
    end
  end
end
