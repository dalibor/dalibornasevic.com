Given /^I have comments (.+)$/ do |contents|
  class Comment
    def spam?
      false
    end
  end
  contents.split(', ').reverse.each do |content|
    Factory.create(:comment, :content => content)
  end
end

Given /^I click "([^\"]*)" "([^\"]*)" "([^\"]*)" in "([^\"]*)" block$/ do |text, type, nth, block|
  #puts "#{type}:nth-child(#{nth})"
  click_link_within ".#{block} .#{type}:nth-child(#{nth})", text
end

Then /^I should have "([^\"]*)" comment$/ do |count|
  Comment.count.should == count.to_i
end
