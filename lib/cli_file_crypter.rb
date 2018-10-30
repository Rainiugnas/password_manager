# frozen_string_literal: true

require 'cli'

# Handle actions related to the cli file crypter interface.
module CliFileCrypter
  # Starter point of the cli file crypter.
  # Run CliFileCrypter.run, it use the ARGV arguments to find and execute an action.
  # Catch all PasswordManager::PasswordManagerError to stop the execution and print the error.
  def self.run
    option = success! Cli::Option.new
    storage = success!(Cli::Storage.new option.file)
    password = success!(Cli::Input::PasswordConfirmation.new "Enter your password: \n")

    crypters = [
      PasswordManager::Crypter::Aes.new(password.value),
      PasswordManager::Crypter::Base64.new
    ]

    send find_action(option), storage, crypters, option
  rescue PasswordManager::PasswordManagerError => e
    print e.message
  end

  # Raise a password manager exception with the given message
  # @param message [String] Error message
  # @raise [PasswordManager::PasswordManagerError] Exception raise
  def self.interupt! message; raise PasswordManager::PasswordManagerError, message end

  # Check that the given object have true success and return the object.
  # @param [Object] object Object to check, must respond to success and error method
  # @raise [PasswordManager::PasswordManagerError] When success is false
  def self.success! object
    return object if object.success

    interupt! object.error
  end

  # @!group Actions
  # Encrypt the file
  # @param storage [Storage] Hold and handle the data of the given file
  # @param crypters [Arrays(Crypter)] Crypters to encrypt / decrypt the data
  # @param _option [Option] Parsed ARGV arguments
  def self.encrypt storage, crypters, _option
    crypters.each { |crypter| storage.data = crypter.encrypt storage.data }

    storage.save!
  end

  # Decrypt the file
  # @param storage [Storage] Hold and handle the data of the given file
  # @param crypters [Arrays(Crypter)] Crypters to encrypt / decrypt the data
  # @param _option [Option] Parsed ARGV argumentss
  def self.decrypt storage, crypters, _option
    crypters.reverse_each { |crypter| storage.data = crypter.decrypt storage.data }

    storage.save!
  end

  # Find the option action to execute (encrypt or decrypt)
  # @param option [Option] Hold the action to execute from ARGV
  def self.find_action option
    %i(encrypt decrypt).each do |action|
      return action if option.send action
    end

    interupt! 'Option must be file and either encrypt or decrypt. Other option are not suported.'
  end

  private_class_method :find_action, :encrypt, :decrypt, :success!
end
