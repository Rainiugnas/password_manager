# frozen_string_literal: true

# Success if all the site in the expected array have
#   the same attribute than the site in the actual array
RSpec::Matchers.define :be_crypter do
  match do |actual|
    actual.respond_to?(:encrypt) && actual.respond_to?(:decrypt)
  end
end
