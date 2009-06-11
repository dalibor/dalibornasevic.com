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
    comment = Factory.build(:comment, :post_id => '')
    comment.should_not be_valid
    comment.errors.on(:post_id).should match(/blank/)
  end
  
  it "should validate presence of name" do
    comment = Factory.build(:comment, :name => '')
    comment.should_not be_valid
    comment.errors.on(:name).should match(/blank/)
  end
  
  it "should validate presence of email" do
    comment = Factory.build(:comment, :email => '')
    comment.should_not be_valid
    comment.errors.on(:email).to_a.join.should match(/blank/)
  end

  it "should validate format of email" do
    comment = Factory.build(:comment, :email => 'bla@bla.bla')
    comment.should_not be_valid
    comment.errors.on(:email).to_a.join.should match(/not an email address/)
  end
  
  it "should validate presence of content" do
    comment = Factory.build(:comment, :content => '')
    comment.should_not be_valid
    comment.errors.on(:content).should match(/blank/)
  end
  
  it "should validate format of email when url is not blank" do
    comment = Factory.build(:comment, :url => 'dalibornasevic')
    comment.should_not be_valid
    comment.errors.on(:url).should match(/invalid/)
  end

  it "should not validate format of email when url is blank" do
    comment = Factory.build(:comment, :url => '')
    comment.errors.on(:url).should be_nil
  end

  
  it "should add protocol to url when url doesn't start with http protocol and save the comment" do
    comment = Factory.build(:comment, :url => 'www.dalibornasevic.com')
    comment.should be_valid
    comment.url.should == 'http://www.dalibornasevic.com'
  end
  
  
end
