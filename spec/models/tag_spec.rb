require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Tag do

  it "should respond to taggings" do
    Tag.reflect_on_association(:taggings).should_not be_nil
    Tag.reflect_on_association(:taggings).macro.should == :has_many
    Tag.reflect_on_association(:taggings).class_name.should == 'Tagging'
    Tag.reflect_on_association(:taggings).options[:dependent].should == :destroy
    #Tag.new.should respond_to(:taggings)
  end

  it "should respond to tags" do
    Tag.reflect_on_association(:posts).should_not be_nil
    Tag.reflect_on_association(:posts).macro.should == :has_many
    Tag.reflect_on_association(:posts).class_name.should == 'Post'
    Tag.reflect_on_association(:posts).options[:through].should == :taggings
  end

  it "should assign valid tag_counts" do
    post_with_tags = Factory.build(:post_with_tags)
    post_with_1_tag = Factory.build(:post_with_1_tag)
    post_with_tags.save.should be_true
    post_with_1_tag.save.should be_true
    tag_counts = Tag.tag_counts
    # tag_counts.first.count.should == '2'
    tag_counts.detect{|tc| tc.name == 'Tag1'}.count.should == '2'
    tag_counts.detect{|tc| tc.name == 'Tag2'}.count.should == '1'
    tag_counts.detect{|tc| tc.name == 'Tag3'}.count.should == '1'
  end

  it "should have nice url format using to_param method" do
    post = Factory.build(:tag1, :id => 1)
    post.to_param.should == "tag1"
  end
end
