# frozen_string_literal: true

module Cli
  module Input
    class Password
      attr_reader :value, :error, :success

      def initialize message
        @value = ask! message
        @success = true
      end

      private

      def ask! message
        print message

        STDIN.noecho(&:gets).chomp
      end
    end
  end
end
