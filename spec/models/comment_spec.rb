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
  
  it "should validate presence of post_id" do
    comment = Comment.new(Factory.attributes_for(:comment, :post_id => ''))
    comment.should_not be_valid
    comment.errors.on(:post_id).should match(/blank/)
  end
  
  it "should validate presence of name" do
    comment = Comment.new(Factory.attributes_for(:comment, :name => ''))
    comment.should_not be_valid
    comment.errors.on(:name).should match(/blank/)
  end
  
  it "should validate presence of email" do
    comment = Comment.new(Factory.attributes_for(:comment, :email => ''))
    comment.should_not be_valid
    comment.errors.on(:email).to_a.join.should match(/blank/)
  end

  it "should validate format of email" do
    comment = Comment.new(Factory.attributes_for(:comment, :email => 'bla@bla.bla'))
    comment.should_not be_valid
    comment.errors.on(:email).to_a.join.should match(/not an email address/)
  end
  

  
  it "should validte presence of content" do
    comment = Comment.new(Factory.attributes_for(:comment, :content => ''))
    comment.should_not be_valid
    comment.errors.on(:content).should match(/blank/)
  end
  
    
  
  
  
end
