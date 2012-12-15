require 'spec_helper'

describe Comment do
  describe 'associations' do
    it { should belong_to(:post) }
  end

  describe 'validations' do
    it { should validate_presence_of(:post_id) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:content) }
    it { should validate_format_of(:email).with(EMAIL_REGEX)}

    it "should validate format of url when url is not blank" do
      comment = build(:comment, :url => 'dalibornasevic')
      comment.should_not be_valid
      comment.errors[:url].should include("is invalid")
    end

    it "should not validate format of url when url is blank" do
      comment = create(:comment, :url => '', :post => create(:post))
      comment.should be_valid
      comment.errors[:url].should be_empty
    end

    it "should add protocol to url when url doesn't start with http protocol and save the comment" do
      comment = build(:comment, :url => 'dalibornasevic.com', :post => create(:post))
      comment.save.should be_true
      comment.url.should == 'http://dalibornasevic.com'
    end

  end

  describe "named scopes" do
    before(:each) do
      post = create(:post)
      create(:comment, :post => post)
      create(:comment, :post => post)
      create(:comment, :post => post, :approved => false)
    end

    it "should count all comments" do
      Comment.all.count.should == 3
    end

    it "should count valid comments" do
      Comment.valid_comments.count.should == 2
    end

    it "should count spam comments" do
      Comment.spam_comments.count.should == 1
    end
  end

  describe "request params" do
    def stub_request
      request = mock('request')
      request.stub!(:remote_ip).and_return("127.0.0.1")
      request.stub!(:env).and_return({'HTTP_USER_AGENT' => 'Firefox', 'HTTP_REFERER' => 'http://www.dalibornasevic.com'})
      request
    end

    it "should set request params to model attributes" do
      comment = build(:comment)
      request = stub_request
      comment.request=request
      comment.user_ip.should == request.remote_ip
      comment.user_agent.should == request.env['HTTP_USER_AGENT']
      comment.referrer.should == request.env['HTTP_REFERER']
    end
  end

  describe "comments_count" do
    it "should not increase comments_count in post when spam comment is created" do
      comment = create(:comment, :approved => false)
      comment.post.comments_count.should == 0
    end

    it "should increase comments_count in post when not spam comment is created" do
      comment = create(:comment, :post => create(:post), :approved => true)
      comment.post.comments.size.should == 1
    end

    it "should decrease comment_count in post when comment is marked as spam" do
      comment = create(:comment, :post => create(:post), :approved => true)
      comment.post.comments.size.should == 1
      comment.approved = false
      comment.save
      comment.reload
      comment.post.comments.size.should == 0
    end

    it "should increase comment_count in post when comment is marked as ham" do
      comment = create(:comment, :approved => false)
      comment.post.comments_count.should == 0
      comment.approved = true
      comment.save
      comment.reload
      comment.post.comments.size.should == 1
    end
  end
end
