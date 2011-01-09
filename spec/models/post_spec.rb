require 'spec_helper'

describe Post do
  describe 'associations' do
    it { should have_many(:comments) }
    it { should have_many(:taggings) }
    it { should have_many(:tags) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:content) }
  end

  describe 'create valid post' do
    it "can create post given valid attributes" do
      post = Factory.create(:post)
      post.should be_valid
    end
  end

  describe 'published_at timestamp' do
    it "should not set published_at timestamp if publish is false" do
      post = Factory.build(:post, :publish => false)
      post.save.should be_true
      post.published_at.should be_nil
    end

    it "should set published_at timestamp if publish is true" do
      post = Factory.build(:post, :publish => true)
      post.save.should be_true
      post.published_at.should_not be_nil
    end

    it "published_at timestamp does not change when editing record without changing publish" do
      published_at = Time.now - 1.day
      post = Factory.create(:post, :publish => true, :published_at => published_at)
      post.title = 'New title'
      post.save!
      post.published_at.should == published_at
    end
  end

  describe "tags" do
    it "should keep tag_names after unsuccessful save and new tags" do
      post = Factory.build(:post, :title => '')
      post.save.should be_false
      post.tag_names.should == Factory.build(:post ,:title => '').tag_names
    end

    it "should keep tag_names after unsuccessful save and tags exist" do
      Factory.create(:tag, :name => 'tag4')
      Factory.create(:tag, :name => 'tag5')
      post = Factory.build(:post, :title => '', :tag_names => 'tag4 tag5')
      post.save.should be_false
      post.tag_names.should == 'tag4 tag5'
    end

    it "tags are empty when tag_names is nil" do
      post = Factory.build(:post, :tag_names => nil)
      post.should be_valid
      post.tags.should == []
    end

    it "should assign_tags" do
      post = Factory.create(:post, :tag_names => 'tag1 tag2 tag3')
      post.tags.map(&:name).should == ['tag1', 'tag2', 'tag3']
    end
  end

  describe "to_param" do
    it "should have nice url format using to_param method" do
      post = Factory.build(:post, :id => 1)
      post.to_param.should == "1-my-first-blog-post"
    end
  end
end
