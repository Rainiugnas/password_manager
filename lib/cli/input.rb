# frozen_string_literal: true

require_relative 'input/password'
require_relative 'input/password_confirmation'
require_relative 'input/site'
require_relative 'input/stop'

module Cli
  # Namespace which contains all input classes.
  # Input classe will ask for std_in interaction at initialization.
  module Input
  end
end
