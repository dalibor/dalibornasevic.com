require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Post do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :content => "value for content"
    }
  end

  it "should create a new instance given valid attributes" do
    Post.create!(@valid_attributes)
  end

  it "should not create a new instance given not valid attributes" do
    post = Factory.build(:post, :title => '', :content => '')
    post.should_not be_valid
  end
end
