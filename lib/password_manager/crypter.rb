# frozen_string_literal: true

require_relative 'crypter/aes'
require_relative 'crypter/base64'

module PasswordManager
  # Namespace which contains all crypter classes.
  # A crypter have an encrypt and decrypt method use to format data.
  module Crypter
  end
end
