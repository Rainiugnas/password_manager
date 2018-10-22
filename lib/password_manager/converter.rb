# frozen_string_literal: true

module PasswordManager
  # Convert data between several format (site array, json, encoded)
  # Use the given crypters to encode / decode.
  #
  # Converter is build from formated data,
  #   parse and store the data and can be re-use to re-format the data
  #
  # Encoding apply the first crypter and apply the next one.
  # Decoding apply the last crypter and apply the previous one.
  # @private @attr [Array(Site)] data All the site from the given data
  # @private @attr [Array(Crypter)] crypters Store the crypters to apply
  class Converter
    # @!group From
    # Build the converter from crypted data
    # @param data [String] Encoded data
    # @param crypterse [Array(Crypter)] Crypters to use to encode / decode
    # @return [Converter] Converter with the site array from the given data
    def self.from_crypt data, crypters
      crypters.reverse_each { |crypter| data = crypter.decrypt data }

      Converter.from_json data, crypters
    end

    # Build the converter from json data
    # @param data [String] Json data
    # @param crypterse [Array(Crypter)] Crypters to use to encode / decode
    # @raise [ConverterError] When the data have json formating error
    # @return [Converter] Converter with the site array from the given data
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

    # Build the converter from site array
    # @param data [Array(Site)] Site to convert
    # @param crypterse [Array(Crypter)] Crypters to use to encode / decode
    # @return [Converter] Converter with the site array from the given data
    def self.from_array data, crypters; Converter.new data, crypters end
    # @!endgroup

    # @deprecated Use {.from_array} instead
    def initialize data, crypters
      @crypters = crypters
      @data = data
    end

    # TODO: freeze the array to avoid concurrent error
    # @!group To
    # @return [Site(Array)] The raw site array
    def to_array; @data end

    # @return [String] The data formated into json string
    def to_json
      hash = {}.tap do |result|
        to_array.each do |site|
          result[site.name] = { 'username' => site.user, 'password' => site.password }
        end
      end

      JSON.generate hash
    end

    # @return [String] The data formatted in to encoded string
    def to_crypt
      data = to_json

      @crypters.each { |crypter| data = crypter.encrypt data }
      data
    end
  end
end
