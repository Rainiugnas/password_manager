# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'password_manager/version'

Gem::Specification.new do |spec|
  spec.name          = 'password_manager'
  spec.version       = PasswordManager::VERSION
  spec.authors       = ['Rainiugnas']
  spec.email         = ['aqdtvz9@gmail.com']

  spec.summary       = 'Handle encryption of json data which contains web site passwords.'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'bin/exe'
  spec.executables   = spec.files.grep(%r{^bin/exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # DEPENDENCIES

  # Tools
  # Monkey patch basic classes like Hash, Array, ... to add extra methods
  spec.add_runtime_dependency 'activesupport', '~> 5.1.6'
end
