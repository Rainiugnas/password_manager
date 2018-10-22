# frozen_string_literal: true

module Cli
  module Input
    # Model to retrieve site data from the input
    class Site < PasswordManager::Site
      # Build the site with the data from the input
      def initialize
        super ask_site_name!, ask_user_name!, Password.new("password: \n").value
      end

      private

      # Ask for the site name and return the result
      # @return [String]
      def ask_site_name!
        puts 'sitename: '

        STDIN.gets.chomp
      end

      # Ask for the user name and return the result
      # @return [String]
      def ask_user_name!
        puts 'username: '

        STDIN.gets.chomp
      end
    end
  end
end
