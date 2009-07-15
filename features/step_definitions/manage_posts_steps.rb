Given /^I am logged in$/ do
  basic_auth(USERNAME, PASSWORD)
#  header('HTTP_AUTHORIZATION', "Basic #{["#{USERNAME}:#{PASSWORD}"].pack("m*")}")
end

Given /^I have posts titled (.+)$/ do |titles|
  titles.split(', ').each do |title|
    Factory.create(:post, :title => title)
  end
end

Given /^I have no posts$/ do
  Post.delete_all
end

Then /^I should have (\d+) post.?$/ do |count|
  Post.count.should == count.to_i
end

Given /^I have created posts titled (.+)$/ do |titles|
  titles.split(', ').each do |title|
    Factory.create(:post, :title => title)
  end
end