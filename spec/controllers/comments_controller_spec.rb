require 'spec_helper'

describe CommentsController do
  context "valid comment" do
    before :each do
      @post_mock = mock_model(Post)
      @comment_mock = mock_model(Comment)

      Post.stub_chain(:where, :find).with("1").and_return(@post_mock)
      @post_mock.stub_chain(:comments, :new).and_return(@comment_mock)
      @comment_mock.stub!(:request=)
      @comment_mock.stub!(:save).and_return(true)
      @chain = mock('chain')
    end

    it "should find post" do
      Post.should_receive(:where).with("comments_closed = 0").and_return(@chain)
      @chain.should_receive(:find).with("1").and_return(@post_mock)
      post :create, :post_id => "1", :comment=>{:name=>"value"}
    end

    it "should initialize new comment successfully" do
      Post.should_receive(:where).with("comments_closed = 0").and_return(@chain)
      @chain.should_receive(:find).with("1").and_return(@post_mock)
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

      Post.stub_chain(:where, :find).with("1").and_return(@post_mock)
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

    it "should render new action" do
      post :create, :post_id => "1", :post=>{:name=>"value"}
      response.should render_template("comments/new")
    end

    it "should display flash error" do
      post :create, :post_id => "1", :comment=>{:name=>"value"}
      flash[:error].should == "Please enter correct reCaptcha."
    end
  end

  context "spam comment" do

    before(:each) do
      @post_mock = mock_model(Post)
      @comment_mock = mock_model(Comment)

      Post.stub_chain(:where, :find).with("1").and_return(@post_mock)
      @post_mock.stub_chain(:comments, :new).and_return(@comment_mock)
      @comment_mock.stub!(:request=)
      @comment_mock.stub!(:save).and_return(true)
    end

    it "should save the comment successfully" do
      @comment_mock.should_receive(:save).and_return(true)
      post :create, :post_id => "1", :comment=>{:name=>"value"}
    end

    it "should redirect to post path" do
      post :create, :post_id => "1", :comment=>{:name=>"value"}
      response.should redirect_to(post_path(@post_mock))
    end
  end
end
