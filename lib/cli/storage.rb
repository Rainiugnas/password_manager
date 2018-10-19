# frozen_string_literal: true

require 'json'

module Cli
  class Storage
    attr_accessor :data, :error, :success

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

    def reload; @data = File.read @path end

    def save!; File.write @path, @data end

    private

    def valid_file?; File.writeable?(@path) && File.readable?(@path) end
  end
end
