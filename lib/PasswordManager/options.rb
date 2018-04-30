require 'optparse'
require 'singleton'

class PasswordManager::Options
  include Singleton

  def self.method_missing name, *args, &block
    raise NoMethodError, "#{name} is not an option." unless instance.options.has_key? name

    instance.options[name]
  end

  def initialize
    @options = default_options

    parser.parse!
    valid_options!
  rescue OptionParser::MissingArgument, OptionParser::InvalidOption => exception
    abort exception.message
  end

  def parser
    @parser ||= OptionParser.new do |parser|
      parser.banner = 'Usage: example.rb -f ./filepath [options]'
      parser.separator ''
      parser.separator 'The rsa key must have a password else it will abort'
      parser.separator ''
      parser.separator ''

      parser.on('-k', '--key path', descriptions[:key]) { |option| @options[:key] = option.freeze }
      parser.on('-f', '--file path', descriptions[:file]) { |option| @options[:file] = option.freeze }

      parser.on('-E', '--encode', descriptions[:encode]) { |option| @options[:encode] = option.freeze }
      parser.on('-D', '--decode', descriptions[:decode]) { |option| @options[:decode] = option.freeze }

      parser.on('-S', '--show sitename', descriptions[:show]) { |option| @options[:show] = option.freeze }
      parser.on('-A', '--add', descriptions[:add]) { |option| @options[:add] = option.freeze }
      parser.on('-L', '--list', descriptions[:list]) { |option| @options[:list] = option.freeze }

      parser.on('-T', '--tmp', descriptions[:tmp]) { |option| @options[:tmp] = option.freeze }

      parser.separator ''
      parser.separator 'The options --show, --add, --list must be associate with a specific --file.'
      parser.separator 'It\' a json file, the key is the site name and each key have an username and a password field.'
    end
  end

  def valid_options!
    abort 'Error: file (option -f / --file) must be provided' if @options[:file].nil?
    abort 'Error: can not use the options --encode, --decode, --show, --add and --list in the same time. Pick just one option' if count_set(:encode, :decode, :show, :add, :list, :tmp) > 1
  end

  def descriptions
    @descriptions ||= {
      help: 'Show this help message and quit',
      key: 'Path of the private rsa key use to encrypt / decrypt. Use ~/.ssh/id_rsa by default',
      file: '[required] Path of the file to encrypt / decrypt',
      encode: 'Encode the file with the rsa key',
      decode: 'Decode the file with the rsa key',
      show: 'Show the information associate to the given site name',
      add: 'Add a site name and associate username / password to it',
      list: 'List all the site name',
      tmp: 'Decrypt the file temporary and the re encrypt it.',
    }
  end

  def default_options
    {
      key: "#{ENV['HOME']}/.ssh/id_rsa",
      encode: false,
      decode: false,
      show: false,
      add: false,
      list: false,
      tmp: false
    }
  end

  def options
    @options.freeze
  end

  def set? option
    !!options[option]
  end

  def count_set *options
    to_number = { false => 0, true => 1 }

    options.map { |option| to_number[set? option] }.sum
  end
end
