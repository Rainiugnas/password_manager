# frozen_string_literal: true

module Cli
  module Input
    class Stop
      attr_reader :value, :error, :success

      def initialize message
        press_to_continue! message

        @success = true
      end

      private

      def press_to_continue! message
        print message

        STDIN.gets
      end
    end
  end
end
