# frozen_string_literal: true

module Cli
  module Input
    # Model to retrieve password data from the input
    # @attr_reader [String] value The password from input
    # @attr_reader [String] error Alway nil
    # @attr_reader [Boolean] success Alway true
    class Password
      attr_reader :value, :error, :success

      # Ask the password with the given message.
      # @param [String] message The message displayed to ask the password
      def initialize message
        @value = ask! message
        @success = true
      end

      private

      # Ask the password with the given message and return the result
      # @param [String] message
      # @return [String]
      def ask! message
        print message

        STDIN.noecho(&:gets).chomp
      end
    end
  end
end
