# frozen_string_literal: true

module PasswordManager
  class Site
    attr_reader :name, :user, :password
    attr_reader :success, :error

    def initialize name, user, password
      @name = name
      @user = user
      @password = password

      @success = true
      valid_name!
      valid_user!
    end

    private

    def valid_name!
      return unless @name.blank?

      @success = false
      @error = 'Error: site name must be present'
    end

    def valid_user!
      return unless @user.blank?

      @success = false
      @error = 'Error: user name must be present'
    end
  end
end
