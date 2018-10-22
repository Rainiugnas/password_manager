# frozen_string_literal: true

require 'password_manager'

require 'cli/input/password'
require 'cli/input/password_confirmation'
require 'cli/input/site'
require 'cli/input/stop'

require 'cli/option'
require 'cli/storage'

module Cli
  def self.interupt! message; raise PasswordManager::PasswordManagerError, message end

  def self.encode storage, crypters, _option
    storage.data = Converter.from_json(storage.data, crypters).to_crypt
    storage.save!
  end

  def self.decode storage, crypters, _option
    storage.data = Converter.from_crypt(storage.data, crypters).to_json
    storage.save!
  end

  def self.list storage, crypters, _option
    sites = Converter.from_crypt(storage.data, crypters).to_array

    puts "Found #{sites.count} sites names:"
    sites.each { |site| puts site.name }
  end

  def show storage, crypters, option
    sites = Converter.from_crypt(storage.data, crypters).to_array
    target = sites.select { |site| site.name == option.show }.try :first

    interupt! "Error: '#{option.show}' is not a valid site name" if target.nil?

    puts "Data associated to #{target.name}:"
    puts "- username: #{target.user}"
    puts "- password: #{target.password}"
  end

  def self.add storage, crypters, _option
    site = Site.new
    interupt! site.error unless site.success

    converter = Converter.from_crypt storage.data, crypters
    converter.to_array.push site

    storage.data = converter.to_crypt
    storage.save!
  end

  def self.tmp storage, crypters, _option
    decode storage, crypters, nil

    Stop.new

    storage.reload
    encode storage, crypters, nil
  end

  def self.find_action option
    %i(encode decode add show list tmp).each do |action|
      return action if option.send action
    end
  end

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
end
