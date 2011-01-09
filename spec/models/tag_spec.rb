require 'spec_helper'

describe Tag do
  describe "associations" do
    it { should have_many(:taggings) }
    it { should have_many(:posts) }
  end

  it "should assign valid tag_counts" do
    post1 = Factory.create(:post, :publish => true, :published_at => Time.now)
    post1.tags << Factory.create(:tag, :name => 'tag1')
    post1.tags << Factory.create(:tag, :name => 'tag2')

    post2 = Factory.create(:post, :publish => true, :published_at => Time.now)
    post2.tags << Factory.create(:tag, :name => 'tag1')
    post2.tags << Factory.create(:tag, :name => 'tag3')

    tag_counts = Tag.tag_counts
    tag_counts.detect{|tc| tc.name == 'tag1'}.count.should == 2
    tag_counts.detect{|tc| tc.name == 'tag2'}.count.should == 1
    tag_counts.detect{|tc| tc.name == 'tag3'}.count.should == 1
  end

  it "should have nice url format using to_param method" do
    post = Factory.create(:tag, :name => 'tag')
    post.to_param.should == "tag"
  end
end
