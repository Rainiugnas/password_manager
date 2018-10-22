# frozen_string_literal: true

module Cli
  module Input
    # Model to stop the program execution and wait for input
    # @attr_reader [String] value Data from input, alway nil
    # @attr_reader [String] error Alway nil
    # @attr_reader [Boolean] success Alway true
    class Stop
      attr_reader :value, :error, :success

      # Stop the execution with the given message and wait for input
      # @param [String] message Message displayed to ask input
      def initialize message
        press_to_continue! message

        @success = true
      end

      private

      # Stop the execution with the given message and wait for input
      # @param [String] message
      def press_to_continue! message
        print message

        STDIN.gets
      end
    end
  end
end
