module Cli
  class Site < PasswordManager::Site
    def initialize
      super ask_site_name!, ask_user_name!, Password.new("password: \n").value
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
  end
end
