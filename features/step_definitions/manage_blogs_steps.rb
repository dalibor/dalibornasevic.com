Given /^I have posts titled (.+)$/ do |titles|
  titles.split(', ').each do |title|
    Blog.create!(:title => title)
  end
end

