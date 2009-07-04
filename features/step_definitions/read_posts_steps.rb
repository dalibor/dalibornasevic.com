Given /^Site has posts titled (.+)$/ do |titles|
  titles.split(', ').each do |title|
    Factory.create(:post, :title => title)
  end
end

Given /^Site has unpublished posts titled "([^\"]*)"$/ do |title|
  Factory.create(:post, :title => title, :published_at => nil)
end