# frozen_string_literal: true

module Cli
  module Input
    # Model to retrieve password with confirmation from the input
    # @private @attr [Password] value Hold the password value
    # @attr_reader [String] error Hold the validation error message (nil if no error)
    # @attr_reader [Boolean] success True if the validation success else false
    class PasswordConfirmation
      attr_reader :error, :success

      # Ask for the password and confirmation with the given message.
      # Success if the confirmation is the same than the password.
      # @param [String] message The message displayed to ask the password
      def initialize message
        @value = Password.new message

        confirm_value!
      end

      # @return [String] The password value
      def value() @value.value end

      private

      # Set success to true if password is the same than confirmation.
      # Else set success to false and add error message.
      def confirm_value!
        confirmation = Password.new 'Please enter password confirmation: '

        if value == confirmation.value
          @success = true
        else
          @error = 'The password does not match the confirmation'
          @success = false
        end
      end
    end
  end
end
