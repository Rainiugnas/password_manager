# frozen_string_literal: true

# rubocop:disable Style/MixinUsage

require 'bundler/setup'

require 'PasswordManager'
require 'cli'
require 'byebug'

require 'dummies/dummy_crypter'

include PasswordManager
include PasswordManager::Crypter
include Cli
include Cli::Input

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
