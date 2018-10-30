# frozen_string_literal: true

# rubocop:disable Style/MixinUsage

# Launch test coverage
require 'simplecov'
SimpleCov.start

require 'bundler/setup'

# Lib
require 'password_manager'
require 'cli'
require 'cli_file_crypter'
require 'byebug'

# Spec tools
require 'dummies/dummy_crypter'
require 'matcher/match_site_array'
require 'matcher/be_crypter'

# Use the lib element without namespace
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
