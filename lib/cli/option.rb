# frozen_string_literal: true

require 'optparse'

# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/BlockLength
# rubocop:disable Metrics/AbcSize

module Cli
  # Use to parse the ARGV argument.
  # The file must be set and one action (encrypt, decrypt, list, show, add, tmp) must be set.
  # @attr_reader [String] file The file path or nil if not set (required)
  # @attr_reader [Boolean] encrypt True or false if not set
  # @attr_reader [Boolean] decrypt True or false if not set
  # @attr_reader [String] show Site name to find show or nil if not set
  # @attr_reader [Boolean] add True or false if not set
  # @attr_reader [Boolean] tmp True or false if not set
  #
  # @attr_reader [String] error Hold the validation error message (nil if no error)
  # @attr_reader [Boolean] success True if the validation success else false
  class Option
    attr_reader :file, :encrypt, :decrypt, :show, :add, :list, :tmp
    attr_reader :success, :error

    # Parse the ARGV and check that the file and the action is set.
    # Set the success to false and error message if the validation fail.
    def initialize
      @encrypt = @decrypt = @add = @list = @tmp = false
      @success = true

      build_parser.parse!
      valid_options!
    rescue OptionParser::MissingArgument, OptionParser::InvalidOption => exception
      @error = exception.message
      @success = false
    end

    private

    # @return [OptionParser] Build, set up and return the ARGV parser
    def build_parser
      OptionParser.new do |parser|
        parser.banner = 'Usage: example.rb -f ./filepath [options]'
        parser.separator ''

        parser.on(
          '-f',
          '--file path',
          '[required] Path of the file to encrypt / decrypt'
        ) { |option| @file = option.freeze }

        parser.on(
          '-e',
          '--encrypt',
          'Encrypt the file with the rsa key'
        ) { @encrypt = true }

        parser.on(
          '-d',
          '--decrypt',
          'Decrypt the file with the rsa key'
        ) { @decrypt = true }

        parser.on(
          '-s',
          '--show sitename',
          'Show the information associate to the given site name'
        ) { |option| @show = option.freeze }

        parser.on(
          '-a',
          '--add',
          'Add a site name and associate username / password to it'
        ) { @add = true }

        parser.on(
          '-l',
          '--list',
          'List all the site name'
        ) { @list = true }

        parser.on(
          '-t',
          '--tmp',
          'Decrypt the file temporary and the re encrypt it.'
        ) { @tmp = true }

        parser.on(
          '--help',
          'Show the command usage.'
        ) { raise OptionParser::InvalidOption, parser.help }

        parser.separator <<~MSG

          The options --encrypt, --decrypt, --show, --add, --tmp and --list must be associate with a specific --file.
          It's a json file, the key is the site name and each key have an username and a password field.
        MSG
      end
    end

    # @raise [OptionParser::InvalidOption] When the file is not set
    # @raise [OptionParser::InvalidOption] When 0 or more than 1 action is set
    def valid_options!
      unless [@encrypt, @decrypt, @show, @add, @list, @tmp].one?
        raise OptionParser::InvalidOption, <<~MSG
          you must set one (no more) of the following options: --encrypt, --decrypt, --show, --add, --tmp and --list
        MSG
      end

      message = 'file (option -f / --file) must be provided'
      raise OptionParser::InvalidOption, message if @file.nil?
    end
  end
end
