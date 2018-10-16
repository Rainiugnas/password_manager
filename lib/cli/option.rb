# frozen_string_literal: true

require 'optparse'

module Cli
  class Option
    attr_reader :file, :encode, :decode, :show, :add, :list, :tmp
    attr_reader :success, :error

    def initialize
      @encode = @decode = @add = @list = @tmp = false
      @success = true

      build_parser.parse!
      valid_options!
    rescue OptionParser::MissingArgument, OptionParser::InvalidOption => exception
      @error = exception.message
      @success = false
    end

    private

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/BlockLength
    # rubocop:disable Metrics/AbcSize
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
          '--encode',
          'Encode the file with the rsa key'
        ) { @encode = true }

        parser.on(
          '-d',
          '--decode',
          'Decode the file with the rsa key'
        ) { @decode = true }

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

          The options --encode, --decode, --show, --add, --tmp and --list must be associate with a specific --file.
          It's a json file, the key is the site name and each key have an username and a password field."
        MSG
      end
    end

    def valid_options!
      unless [@encode, @decode, @show, @add, @list, @tmp].one?
        raise OptionParser::InvalidOption, <<~MSG
          you must set one (no more) of the following options: --encode, --decode, --show, --add, --tmp and --list
        MSG
      end

      message = 'file (option -f / --file) must be provided'
      raise OptionParser::InvalidOption, message if @file.nil?
    end
  end
end
