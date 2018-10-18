class DummyCrypter
  def initialize salt; @salt = "#{salt}:" end

  def encrypt data; "#{@salt}#{data}" end
  def decrypt data; data[@salt.size..-1] end
end
