# frozen_string_literal: true

module PasswordManager
  class PasswordManagerError < Exception; end

  class DecryptError < PasswordManagerError; end
  class EncryptError < PasswordManagerError; end

  class ConverterError < PasswordManagerError; end
end
