# frozen_string_literal: true

module PasswordManager
  class Converter
    def self.from_crypt data, crypters
      crypters.reverse_each { |crypter| data = crypter.decrypt data }

      Converter.from_json data, crypters
    end

    def self.from_json data, crypters
      data = [].tap do |result|
        sites = JSON.parse data

        sites.each do |name, values|
          result.push Site.new name, values['username'], values['password']
        end
      end

      Converter.from_array data, crypters
    rescue JSON::ParserError
      raise ConverterError, 'Error: the json provided is invalid'
    end

    def self.from_array data, crypters; Converter.new data, crypters end

    def initialize data, crypters
      @crypters = crypters
      @data = data
    end

    def to_array; @data end

    def to_json
      hash = {}.tap do |result|
        to_array.each do |site|
          result[site.name] = { 'username' => site.user, 'password' => site.password }
        end
      end

      JSON.generate hash
    end

    def to_crypt
      data = to_json

      @crypters.each { |crypter| data = crypter.encrypt data }
      data
    end
  end
end
