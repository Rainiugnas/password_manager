# frozen_string_literal: true

require 'json'

module Cli
  # Model to handle file data access.
  # @attr [data] data Data read from to file or to write into the file
  # @private @attr [data] path Store the path of the file
  # @attr_reader [String] error Hold the validation error message (nil if no error)
  # @attr_reader [Boolean] success True if the validation success else false
  class Storage
    attr_accessor :data
    attr_reader :error, :success

    # Read the value of the file associated to the given path.
    # Set success to false if the file is not writable and readable.
    # @param [String] path The path associated to the targeted file
    def initialize path
      @path = path.freeze

      if valid_file?
        @data = File.read @path
        @success = true
      else
        @error = 'Error: the given file have not read and write right'
        @success = false
      end
    end

    # Read the file and store the data in data attribute
    def reload; @data = File.read @path end

    # Write the data into the file
    def save!; File.write @path, @data end

    private

    # @return [Boolean] True if the file is writable and readable else false
    def valid_file?; File.writable?(@path) && File.readable?(@path) end
  end
end
