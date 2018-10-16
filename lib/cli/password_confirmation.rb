# frozen_string_literal: true

module Cli
  class PasswordConfirmation
    attr_reader :error, :success

    def initialize message
      @value = Password.new message

      confirm_value!
    end

    def value() @value.value end

    private

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
