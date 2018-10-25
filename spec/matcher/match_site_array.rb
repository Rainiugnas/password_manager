# frozen_string_literal: true

# Success if all the site in the expected array have
#   the same attribute than the site in the actual array
RSpec::Matchers.define :match_site_array do |expected|
  match do |actual|
    return false if actual.size != expected.size

    expected.each_with_index.map do |site, index|
      site.name == actual[index].name &&
        site.user == actual[index].user &&
        site.password == actual[index].password &&
        site.extra == actual[index].extra
    end.all?
  end
end
