require 'spec_helper'

describe CommentsController do
  context "valid comment" do
    before :each do
      @post_mock = mock_model(Post)
      @comment_mock = mock_model(Comment)

      Post.stub!(:find).with("1", :conditions => "comments_closed = 0").and_return(@post_mock)
      @post_mock.stub_chain(:comments, :new).and_return(@comment_mock)
      @comment_mock.stub!(:request=)
      @comment_mock.stub!(:save).and_return(true)
      @comment_mock.stub!(:approved?).and_return(true)
    end

    it "should find post" do
      Post.should_receive(:find).with("1", :conditions => "comments_closed = 0").and_return(@post_mock)
      post :create, :post_id => "1", :comment=>{:name=>"value"}
    end

    it "should initialize new comment successfully" do
      Post.should_receive(:find).and_return(@post_mock)
      @post_mock.comments.should_receive(:new).and_return(@comment_mock)
      post :create, :post_id => "1", :comment=>{:name=>"value"}
    end

    it "should set request params successfully" do
      @comment_mock.should_receive(:request=)
      post :create, :post_id => "1", :comment=>{:name=>"value"}
    end

    it "should save the comment successfully" do
      @comment_mock.should_receive(:save).and_return(true)
      post :create, :post_id => "1", :comment=>{:name=>"value"}
    end

    it "should have approved comment" do
      @comment_mock.should_receive(:approved?).and_return(true)
      post :create, :post_id => "1", :comment=>{:name=>"value"}
    end

    it "should display flash notice when comment is approved" do
      post :create, :post_id => "1", :comment=>{:name=>"value"}
      flash[:notice].should == "Your comment was successfully created."
    end

    it "should redirect to post path" do
      post :create, :post_id => "1", :comment=>{:name=>"value"}
      response.should redirect_to(post_path(@post_mock))
    end
  end

  context "invalid comment" do

    before(:each) do
      @post_mock = mock_model(Post)
      @comment_mock = mock_model(Comment)

      Post.stub!(:find).with("1", :conditions => "comments_closed = 0").and_return(@post_mock)
      @post_mock.stub_chain(:comments, :new).and_return(@comment_mock)
      @comment_mock.stub!(:request=)
      @comment_mock.stub!(:save).and_return(false)
    end

    it "should not save the comment" do
      @comment_mock.should_receive(:save).and_return(false)
      post :create, :post_id => "1", :comment=>{:name=>"value"}
    end

    it "should assign comment" do
      post :create, :post_id => "1", :comment=>{:name=>"value"}
      assigns(:comment).should == @comment_mock
    end

    it "should assing post" do
      post :create, :post_id => "1", :comment=>{:name=>"value"}
      assigns(:post).should == @post_mock
    end

    it "should assing comments" do
      post :create, :post_id => "1", :comment=>{:name=>"value"}
      assigns(:comments).should_not be_nil
    end

    it "should render new action" do
      post :create, :post_id => "1", :post=>{:name=>"value"}
      response.should render_template("posts/show")
    end

    it "should display flash error" do
      post :create, :post_id => "1", :comment=>{:name=>"value"}
      flash[:error].should == "Please correct invalid data from the form."
    end
  end

  context "spam comment" do

    before(:each) do
      @post_mock = mock_model(Post)
      @comment_mock = mock_model(Comment)

      Post.stub!(:find).with("1", :conditions => "comments_closed = 0").and_return(@post_mock)
      @post_mock.stub_chain(:comments, :new).and_return(@comment_mock)
      @comment_mock.stub!(:request=)
      @comment_mock.stub!(:save).and_return(true)
      @comment_mock.stub!(:approved?).and_return(false)
    end

    it "should save the comment successfully" do
      @comment_mock.should_receive(:save).and_return(true)
      post :create, :post_id => "1", :comment=>{:name=>"value"}
    end

    it "should create not approved comment" do
      @comment_mock.should_receive(:approved?).and_return(false)
      post :create, :post_id => "1", :comment=>{:name=>"value"}
    end

    it "should redirect to post path" do
      post :create, :post_id => "1", :comment=>{:name=>"value"}
      response.should redirect_to(post_path(@post_mock))
    end

    it "should display flash error" do
      post :create, :post_id => "1", :comment=>{:name=>"value"}
      flash[:error].should == "Unfortunately this comment is considered spam by Akismet. It will show up once it has been approved by the administrator."
    end
  end
end
