require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Comment do
#  before(:each) do
#    @valid_attributes = {
#      :post => Post.new,
#      :name => "value for name",
#      :email => "value for email",
#      :content => "value for content"
#    }
#  end

  it "should respond to post" do
    Comment.reflect_on_association(:post).should_not be_nil
  end
  
end
