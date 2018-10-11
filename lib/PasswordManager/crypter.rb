# frozen_string_literal: true

require 'openssl'
require 'base64'
require 'digest/sha2'

class PasswordManager::Crypter
  def initialize password
    @password = password
    @cipher = OpenSSL::Cipher.new 'AES-256-CBC'
  end

  def key
    @key ||= begin
      digest = Digest::SHA256.new
      digest.update @password
      digest.digest
    end
  end

  def iv
    @iv ||= key[0..15]
  end

  def method_missing name, *args, &block
    super name, *args, &block unless %i(encrypt decrypt).include? name

    @cipher.reset
    @cipher.send name
    @cipher.key = key
    @cipher.iv = iv
    @cipher.update(args[0]) + @cipher.final
  end

  def encrypt_base64 data
    Base64.encode64 encrypt data
  end

  def decrypt_base64 data
    decrypt Base64.decode64 data
  end
end
