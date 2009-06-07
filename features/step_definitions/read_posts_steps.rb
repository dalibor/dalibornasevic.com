Given /^Site has posts titled (.+)$/ do |titles|
  titles.split(', ').each do |title|
    Factory.create(:post, :title => title)
  end
end