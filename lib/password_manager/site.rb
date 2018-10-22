# frozen_string_literal: true

module PasswordManager
  # Model for site data
  # @attr_reader [String] name The site name, also the key use to store the site (required)
  # @attr_reader [String] user The username associated to the site (required)
  # @attr_reader [String] password The password associated to the site
  # @attr_reader [String] error Hold the validation error message (nil if no error)
  # @attr_reader [Boolean] success True if the validation success else false
  class Site
    attr_reader :name, :user, :password
    attr_reader :success, :error

    # Initialize the attributes and check their validity
    def initialize name, user, password
      @name = name
      @user = user
      @password = password

      @success = true
      valid_name!
      valid_user!
    end

    private

    # Check if the name is present
    # @return [Boolean] True if the site name is present else false
    def valid_name!
      return unless @name.blank?

      @success = false
      @error = 'Error: site name must be present'
    end

    # Check if the user is present
    # @return [Boolean] True if the user is present else false
    def valid_user!
      return unless @user.blank?

      @success = false
      @error = 'Error: user name must be present'
    end
  end
end
