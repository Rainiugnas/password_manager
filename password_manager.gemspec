# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'password_manager/version'

Gem::Specification.new do |spec|
  spec.name          = 'password_manager'
  spec.version       = PasswordManager::VERSION
  spec.authors       = ['Rainiugnas']
  spec.email         = ['aqdtvz9@gmail.com']

  spec.summary       = 'Write a short summary, because RubyGems requires one.'
  spec.description   = 'Write a longer description or delete this line.'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin/exe'
  spec.executables   = spec.files.grep(%r{^bin/exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
