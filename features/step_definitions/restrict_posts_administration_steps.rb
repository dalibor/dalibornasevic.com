Given /^I am not an administrator$/ do
  basic_auth('wrong_username', 'wrong_password')
end

Given /^Site has post with id (\d+)$/ do |id|
  Factory.create(:post, :id => id)
end

When /^I do create a post in administration$/ do
  post '/admin/posts', :post => {}
end

When /^I do update a post with id (\d+) in administration$/ do |id|
  put 'admin/posts/1', :post => {}
end

When /^I do delete a post with id 1 in administration$/ do
  delete 'admin/posts/1'
end