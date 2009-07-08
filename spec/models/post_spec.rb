require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Post do
#  before(:each) do
#    @valid_attributes = {
#      :title => "value for title",
#      :content => "value for content"
#    }
#  end

  it "should be valid when using valid attributes" do
    post = Factory.build(:post)
    post.should be_valid
    # Post.create!(@valid_attributes)
  end

  it "should not be valid when title is blank" do
    post = Factory.build(:post, :title => '')
    post.should_not be_valid
    post.errors.on(:title).should match(/blank/)
  end
  
  it "should not be valid when content is blank" do
    post = Factory.build(:post, :content => '')
    post.should_not be_valid
    post.errors.on(:content).should match(/blank/)
  end
  
  it "should not be published if publish is '0'" do
    post = Factory.build(:post, :publish => '0')
    post.should be_valid
    post.save.should be_true
    post.published_at.should be_nil
  end
  
  it "should be published if publish is '1'" do
    post = Factory.build(:post)
    post.title = "New Title"
    post.save.should be_true
    post.published_at.should_not be_nil
  end
  
  it "should not delete published_at when editing record and not changing publish" do
    post = Factory.build(:post)
    post.should be_valid
    post.title = 'New title'
    post.published_at.should_not be_nil
  end
  
  it "should keep tag_names when model is not saved and don't exist in database" do
    post = Factory.build(:post, :title => '')
    post.save.should be_false
    post.tag_names.should == Factory.build(:post ,:title => '').tag_names
  end

  it "should keep tag_names when model is not saved and exist in database" do
    post = Factory.build(:post, :title => '', :tag_names => 'Tag4 Tag5')
    post.save.should be_false
    post.tag_names.should == 'Tag4 Tag5'
  end
  
  it "should set tag_names when @tag_name is nil" do
    post = Factory.build(:post_with_tags, :tag_names => nil)
    post.tag_names.should == Factory.build(:post).tag_names
  end
  
  it "should assign_tags" do
    post = Factory.build(:post)
    post_with_tags = Factory.build(:post_with_tags)
    post.save.should be_true
    post.tags.size.should == 3
    post_with_tags.tags.should == post.tags
  end
  
  it "should respond to comments" do
    Post.reflect_on_association(:comments).should_not be_nil
    Post.reflect_on_association(:comments).macro.should == :has_many
    Post.reflect_on_association(:comments).class_name.should == 'Comment'
    #Post.new.should respond_to(:comments)
  end
  
  it "should respond to taggings" do
    Post.reflect_on_association(:taggings).should_not be_nil
    Post.reflect_on_association(:taggings).macro.should == :has_many
    Post.reflect_on_association(:taggings).class_name.should == 'Tagging'
    Post.reflect_on_association(:taggings).options[:dependent].should == :destroy
    #Post.new.should respond_to(:taggings)
  end
  
  it "should respond to tags" do
    Post.reflect_on_association(:tags).should_not be_nil
    Post.reflect_on_association(:tags).macro.should == :has_many
    Post.reflect_on_association(:tags).class_name.should == 'Tag'
    Post.reflect_on_association(:tags).options[:through].should == :taggings
    #Post.new.should respond_to(:tags)
  end
  
  it "should have nice url format using to_param method" do
    post = Factory.build(:post, :id => 1)
    post.to_param.should == "1-my-first-blog-post"
  end
end