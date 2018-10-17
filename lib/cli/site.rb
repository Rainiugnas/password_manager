module Cli
  class Site
    attr_reader :name, :user, :password
    attr_reader :error, :success

    def initialize
      @name = ask_site_name!
      @user = ask_user_name!
      @password = Password.new("password: \n").value

      @success = true
      valid_name!
      valid_user!
    end

    private

    def ask_site_name!
      puts 'sitename: '

      STDIN.gets.chomp
    end

    def ask_user_name!
      puts 'username: '

      STDIN.gets.chomp
    end

    def valid_name!
      return unless @name.empty?

      @success = false
      @error = 'Error: site name must be present'
    end

    def valid_user!
      return unless @user.empty?

      @success = false
      @error = 'Error: user name must be present'
    end
  end
end
