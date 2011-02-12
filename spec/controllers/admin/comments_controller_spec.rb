require 'spec_helper'

describe Admin::CommentsController do
  context "has scoped inherited resources" do
    it "responds to resource" do
      @comment_mock = mock_model(Comment)
      Comment.stub_chain(:on_posts_of, :find).and_return(@comment_mock)
      controller.should respond_to(:resource)
      controller.send(:resource).should == @comment_mock
    end
  end

  describe "list comments" do
    before :each do
      login_as_editor
      @comment_mock = mock_model(Comment)
      @comments = [@comment_mock]
      Comment.stub(:on_posts_of).and_return(@comments)
      @comments.stub(:paginate).and_return(@comments)
    end

    it "should render list of comments successfully" do
      @comments.should_receive(:paginate).and_return([@comment_mock])
      get :index
      response.should be_success
      assigns(:comments).should_not be_nil
    end
  end

  describe "filter comments" do
    before :each do
      editor = login_as_editor
      post = Factory.create(:post, :editor => editor)
      @valid_comment = Factory.create(:comment, :post => post, :approved => true)
      @spam_comment = Factory.create(:comment, :post => post, :approved => false)
      @spam_comment.mark_as_spam!
    end

    it "should render all comments successfully" do
      get :index
      response.should be_success
      assigns(:comments).should == [@spam_comment, @valid_comment]
    end

    it "should render only valid comments" do
      get :index, :type => 'not-spam'
      response.should be_success
      assigns(:comments).should == [@valid_comment]
    end

    it "should render only spam comments" do
      get :index, :type => 'spam'
      response.should be_success
      assigns(:comments).should == [@spam_comment]
    end
  end

  describe "destroy multiple comment" do
    before :each do
      login_as_editor
      @comments = mock_model(Comment)
      Comment.stub(:on_posts_of).and_return(@comments)
      @comments.stub(:destroy)
    end

    it "should redirect if comment_ids is blank" do
      delete :destroy_multiple, :comment_ids => ""
      response.should redirect_to(admin_comments_url)
    end

    it "should call destoy with comment_ids" do
      @comments.should_receive(:destroy).with(['1', '2'])
      delete :destroy_multiple, :comment_ids => ['1', '2']
    end

    it "should set flash notice" do
      delete :destroy_multiple, :comment_ids => ['1', '2']
      flash[:notice].should == 'Comments were successfully destroyed.'
    end
  end

  describe "approve comment" do
    before :each do
      login_as_editor
      @mock_object = mock_model(Comment)
      Comment.stub_chain(:on_posts_of, :find).with("1").and_return(@mock_object)
      @mock_object.stub!(:mark_as_ham!).and_return(true)
    end

    it "should mark as ham comment" do
      @mock_object.should_receive(:mark_as_ham!).and_return(true)
      put :approve, :id => "1", :comment=>{}
      response.should redirect_to(admin_comments_url)
    end

    it "should set flash notice" do
      put :approve, :id => "1", :comment=>{}
      flash[:notice].should == 'Comment was approved successfully.'
    end
  end

  describe "reject comment" do
    before :each do
      login_as_editor
      @mock_object = mock_model(Comment)
      Comment.stub_chain(:on_posts_of, :find).with("1").and_return(@mock_object)
      @mock_object.stub!(:mark_as_spam!).and_return(true)
    end

    it "should mark as spam comment" do
      @mock_object.should_receive(:mark_as_spam!).and_return(true)
      put :reject, :id => "1", :comment=>{}
      response.should redirect_to(admin_comments_url)
    end

    it "should set flash notice" do
      put :reject, :id => "1", :comment=>{}
      flash[:notice].should == 'Comment was rejected successfully.'
    end
  end
end
