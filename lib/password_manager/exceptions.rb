# frozen_string_literal: true

module PasswordManager
  # Global exception class throw by password manager
  class PasswordManagerError < RuntimeError; end

  # Throw by crypter when the decrypt fail
  class DecryptError < PasswordManagerError; end

  # Throw by crypter when the encrypt fail
  class EncryptError < PasswordManagerError; end

  # Throw by converter when the convertion fail
  class ConverterError < PasswordManagerError; end
end
