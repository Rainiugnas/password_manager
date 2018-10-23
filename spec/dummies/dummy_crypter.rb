# frozen_string_literal: true

# Fake crypter, add / remove the salt at the begin of the given data
class DummyCrypter
  def initialize salt; @salt = "#{salt}:" end

  def encrypt data; "#{@salt}#{data}" end
  def decrypt data; data[@salt.size..-1] end
end
