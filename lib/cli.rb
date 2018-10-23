# frozen_string_literal: true

require 'password_manager'

require 'cli/input/password'
require 'cli/input/password_confirmation'
require 'cli/input/site'
require 'cli/input/stop'

require 'cli/option'
require 'cli/storage'

# Handle actions related to the cli interface.
module Cli
  # Raise a password manager exception with the given message
  # @param message [String] Error message
  # @raise [PasswordManager::PasswordManagerError] Exception raise
  def self.interupt! message; raise PasswordManager::PasswordManagerError, message end

  # Starter point of the cli.
  # Run Cli.run, it use the ARGV arguments to find and execute an action.
  # Catch all PasswordManager::PasswordManagerError to stop the execution and print the error.
  def self.run
    option = Option.new
    storage = Storage.new option.file
    password = PasswordConfirmation.new

    [option, storage, password].each { |object| interupt! object.error unless object.success }

    crypters = [
      PasswordManager::Crypter::Aes.new(password.value),
      PasswordManager::Crypter::Base64.new
    ]

    send find_action(option), storage, crypters, option
  rescue PasswordManager::PasswordManagerError => e
    print e.message
  end

  # @!group Actions
  # Encrypt the file (json -> crypted)
  # @param storage [Storage] Hold and handle the data of the given file
  # @param crypters [Arrays(Crypter)] Crypters to encrypt / decrypt the data
  # @param option [Option] Parsed ARGV arguments
  def self.encrypt storage, crypters, _option
    storage.data = Converter.from_json(storage.data, crypters).to_crypt
    storage.save!
  end

  # Decrypt the file (crypted -> json)
  # @param storage [Storage] Hold and handle the data of the given file
  # @param crypters [Arrays(Crypter)] Crypters to encrypt / decrypt the data
  # @param option [Option] Parsed ARGV argumentss
  def self.decrypt storage, crypters, _option
    storage.data = Converter.from_crypt(storage.data, crypters).to_json
    storage.save!
  end

  # List all site name (crypted -> crypted)
  # @param storage [Storage] Hold and handle the data of the given file
  # @param crypters [Arrays(Crypter)] Crypters to encrypt / decrypt the data
  # @param option [Option] Parsed ARGV arguments
  def self.list storage, crypters, _option
    sites = Converter.from_crypt(storage.data, crypters).to_array

    puts "Found #{sites.count} sites names:"
    sites.each { |site| puts site.name }
  end

  # Find the the site and display it's data (crypted -> crypted)
  # @param storage [Storage] Hold and handle the data of the given file
  # @param crypters [Arrays(Crypter)] Crypters to encrypt / decrypt the data
  # @param option [Option] Parsed ARGV arguments, hold the site to find
  def self.show storage, crypters, option
    sites = Converter.from_crypt(storage.data, crypters).to_array
    target = sites.select { |site| site.name == option.show }.try :first

    interupt! "Error: '#{option.show}' is not a valid site name" if target.nil?

    puts "Data associated to #{target.name}:"
    puts "- username: #{target.user}"
    puts "- password: #{target.password}"
  end

  # As the user to enter site data and save it (crypted -> crypted)
  # @param storage [Storage] Hold and handle the data of the given file
  # @param crypters [Arrays(Crypter)] Crypters to encrypt / decrypt the data
  # @param option [Option] Parsed ARGV arguments
  def self.add storage, crypters, _option
    site = Site.new
    interupt! site.error unless site.success

    converter = Converter.from_crypt storage.data, crypters
    converter = Converter.from_array(converter.to_array + [site], crypters)

    storage.data = converter.to_crypt
    storage.save!
  end

  # Decrypt the file and wait for input, then encrypt the file (crypted -> crypted)
  # @param storage [Storage] Hold and handle the data of the given file
  # @param crypters [Arrays(Crypter)] Crypters to encrypt / decrypt the data
  # @param option [Option] Parsed ARGV arguments
  def self.tmp storage, crypters, _option
    decrypt storage, crypters, nil

    Stop.new

    storage.reload
    encrypt storage, crypters, nil
  end

  # Find the option action to execute (encrypt, decrypt, add, show, list, tmp)
  # @param option [Option] Hold the action to execute from ARGV
  def self.find_action option
    %i(encrypt decrypt add show list tmp).each do |action|
      return action if option.send action
    end
  end

  private_class_method :find_action, :encrypt, :decrypt, :add, :show, :list, :tmp
end
