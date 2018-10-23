# frozen_string_literal: true

require 'password_manager'

require 'cli/input'
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
    option = success! Option.new
    storage = success!(Storage.new option.file)
    password = success!(Input::PasswordConfirmation.new "Enter your password: \n")

    crypters = [
      PasswordManager::Crypter::Aes.new(password.value),
      PasswordManager::Crypter::Base64.new
    ]

    send find_action(option), storage, crypters, option
  rescue PasswordManager::PasswordManagerError => e
    print e.message
  end

  # Check that the given object have true success and return the object.
  # @param [Object] object Object to check, must respond to success and error method
  # @raise [PasswordManager::PasswordManagerError] When success is false
  def self.success! object
    return object if object.success

    interupt! object.error
  end

  # Print in std out the data of the given site
  # @param [Site] site
  def self.display_site site
    puts "Data associated to #{site.name}:"
    puts "- username: #{site.user}"
    puts "- password: #{site.password}"
  end

  # @!group Actions
  # Encrypt the file (json -> crypted)
  # @param storage [Storage] Hold and handle the data of the given file
  # @param crypters [Arrays(Crypter)] Crypters to encrypt / decrypt the data
  # @param _option [Option] Parsed ARGV arguments
  def self.encrypt storage, crypters, _option
    storage.data = PasswordManager::Converter.from_json(storage.data, crypters).to_crypt
    storage.save!
  end

  # Decrypt the file (crypted -> json)
  # @param storage [Storage] Hold and handle the data of the given file
  # @param crypters [Arrays(Crypter)] Crypters to encrypt / decrypt the data
  # @param _option [Option] Parsed ARGV argumentss
  def self.decrypt storage, crypters, _option
    storage.data = PasswordManager::Converter.from_crypt(storage.data, crypters).to_json
    storage.save!
  end

  # List all site name (crypted -> crypted)
  # @param storage [Storage] Hold and handle the data of the given file
  # @param crypters [Arrays(Crypter)] Crypters to encrypt / decrypt the data
  # @param _option [Option] Parsed ARGV arguments
  def self.list storage, crypters, _option
    sites = PasswordManager::Converter.from_crypt(storage.data, crypters).to_array

    puts "Found #{sites.count} sites names:"
    sites.each { |site| puts site.name }
  end

  # Find the the site and display it's data (crypted -> crypted)
  # @param storage [Storage] Hold and handle the data of the given file
  # @param crypters [Arrays(Crypter)] Crypters to encrypt / decrypt the data
  # @param option [Option] Parsed ARGV arguments, hold the site to find
  def self.show storage, crypters, option
    sites = PasswordManager::Converter.from_crypt(storage.data, crypters).to_array
    target = sites.select { |site| site.name == option.show }.try :first

    interupt! "Error: '#{option.show}' is not a valid site name" if target.nil?

    display_site target
  end

  # As the user to enter site data and save it (crypted -> crypted)
  # @param storage [Storage] Hold and handle the data of the given file
  # @param crypters [Arrays(Crypter)] Crypters to encrypt / decrypt the data
  # @param _option [Option] Parsed ARGV arguments
  def self.add storage, crypters, _option
    site = success! Input::Site.new

    converter = PasswordManager::Converter.from_crypt storage.data, crypters
    converter = PasswordManager::Converter.from_array(converter.to_array + [site], crypters)

    storage.data = converter.to_crypt
    storage.save!
  end

  # Decrypt the file and wait for input, then encrypt the file (crypted -> crypted)
  # @param storage [Storage] Hold and handle the data of the given file
  # @param crypters [Arrays(Crypter)] Crypters to encrypt / decrypt the data
  # @param _option [Option] Parsed ARGV arguments
  def self.tmp storage, crypters, _option
    decrypt storage, crypters, nil

    Input::Stop.new "Press enter to continue.\n"

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

  private_class_method :find_action, :encrypt, :decrypt, :add, :show,
                       :list, :tmp, :success!, :display_site
end
