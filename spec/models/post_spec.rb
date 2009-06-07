require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Post do
#  before(:each) do
#    @valid_attributes = {
#      :title => "value for title",
#      :content => "value for content"
#    }
#  end

  it "should be valid when using valid attributes" do
    post = Post.new(Factory.attributes_for(:post))
    post.should be_valid
    # Post.create!(@valid_attributes)
  end

  it "should not be valid when title is blank" do
    post = Post.new(Factory.attributes_for(:post, :title => ''))
    post.should_not be_valid
    post.errors.on(:title).should match(/blank/)
  end
  
  it "should not be valid when content is blank" do
    post = Post.new(Factory.attributes_for(:post, :content => ''))
    post.should_not be_valid
    post.errors.on(:content).should match(/blank/)
  end
end
