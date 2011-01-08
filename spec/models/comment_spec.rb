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
    Comment.reflect_on_association(:post).macro.should == :belongs_to
    Comment.reflect_on_association(:post).class_name.should == 'Post'
    # Comment.reflect_on_association(:post).options.should == { :counter_cache => true }
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
    comment.valid?
    comment.errors.on(:url).should be_nil
  end

  it "should add protocol to url when url doesn't start with http protocol and save the comment" do
    comment = Factory.build(:comment, :url => 'www.dalibornasevic.com')
    comment.should be_valid
    comment.url.should == 'http://www.dalibornasevic.com'
  end

  it "should set approved to true when comment is not spam when using Akismet service" do
    Rakismet::KEY.stub!(:blank?).and_return(false)
    comment = Factory.build(:comment, :url => 'www.dalibornasevic.com')
    comment.stub!(:spam?).and_return(false)
    comment.check_for_spam.should == true
    comment.approved.should == true
  end

  it "should set approved to true when comment is not spam when not using Akismet service" do
    Rakismet::KEY.stub!(:blank?).and_return(true)
    comment = Factory.build(:comment, :url => 'www.dalibornasevic.com')
    comment.check_for_spam.should == true
    comment.approved.should == true
  end

  it "should set approved to false when comment is spam using Akismet service" do
    Rakismet::KEY.stub!(:blank?).and_return(false)
    comment = Factory.build(:comment, :url => 'www.dalibornasevic.com')
    comment.stub!(:spam?).and_return(true)
    comment.check_for_spam.should == true
    comment.approved.should == false
  end

  it "should set request params to model attributes" do
    comment = Factory.build(:comment, :url => 'www.dalibornasevic.com')
    request = stub_request
    comment.request=request
    comment.user_ip.should == request.remote_ip
    comment.user_agent.should == request.env['HTTP_USER_AGENT']
    comment.referrer.should == request.env['HTTP_REFERER']
  end

  it "should mark as spam when using Akismet service" do
    comment = Factory.build(:comment)
    comment.stub!(:spam?).and_return(false)
    comment.save!
    comment.stub!(:spam!).and_return(true)
    comment.mark_as_spam!
    comment.approved.should == false
  end

  it "should mark as spam when not using Akismet service" do
    comment = Factory.build(:comment)
    Rakismet::KEY.stub!(:blank?).and_return(true)
    comment.save!
    comment.mark_as_spam!
    comment.approved.should == false
  end

  it "should mark as ham when using Akismet service" do
    comment = create_spam_comment
    comment.stub!(:ham!).and_return(true)
    comment.mark_as_ham!
    comment.approved.should == true
  end

  it "should mark as ham when not using Akismet service" do
    comment = create_spam_comment
    comment.stub!(:ham!).and_return(true)
    comment.mark_as_ham!
    comment.approved.should == true
  end

  it "should not increase comments_count in post when spam comment is created" do
    comment = create_spam_comment
    comment.post.comments.size.should == 0
  end

  it "should increase comments_count in post when not spam comment is created" do
    comment = Factory.create(:comment)
    comment.post.comments.size.should == 1
  end

  it "should decrease comment_count in post when comment is marked as spam" do
    comment = Factory.create(:comment)
    comment.post.comments.size.should == 1
    comment.mark_as_spam!
    comment.reload
    comment.post.comments.size.should == 0
  end

  it "should increase comment_count in post when comment is marked as ham" do
    comment = create_spam_comment
    comment.post.comments.size.should == 0
    comment.save!
    comment.stub!(:ham!).and_return(true)
    comment.mark_as_ham!
    comment.reload
    comment.post.comments.size.should == 1
  end
end

describe Comment, "named scopes" do

  before(:each) do
    Factory.create(:comment) # valid comment
    Factory.create(:comment) # valid comment
    spam_comment = Factory.create(:comment)
    spam_comment.mark_as_spam!
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

private

def create_spam_comment
  comment = Factory.build(:comment)
  Rakismet::KEY.stub!(:blank?).and_return(false)
  comment.stub!(:spam?).and_return(true)
  comment.save!
  comment
end
