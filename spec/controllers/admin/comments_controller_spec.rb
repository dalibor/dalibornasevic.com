require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::CommentsController, "list comments" do

  before(:each) do
    authenticate_with_http_digest(USERNAME, PASSWORD, REALM)
    Comment.stub!(:paginate).and_return(@mock_objects = [mock_model(Comment)])
  end

  it "should render list of comments successfully" do
    Comment.should_receive(:paginate).and_return([@mock_objects])
    get :index
    response.should be_success
    assigns(:comments).should_not be_nil
  end
end

describe Admin::CommentsController, "filter comments" do

  before(:each) do
    authenticate_with_http_digest(USERNAME, PASSWORD, REALM)
    @valid_comment = Factory.create(:comment)
    @spam_comment = Factory.create(:comment)
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

describe Admin::CommentsController, "show comment" do

  before(:each) do
    authenticate_with_http_digest(USERNAME, PASSWORD, REALM)
    Comment.stub!(:find).with("1").and_return(@mock_object = mock_model(Comment))
  end

  it "should render new comment successfully" do
    Comment.should_receive(:find).with("1").and_return(@mock_object)
    get :show, :id => "1"
    response.should be_success
    assigns(:comment).should_not be_nil
  end
end

describe Admin::CommentsController, "edit comment" do

  before(:each) do
    authenticate_with_http_digest(USERNAME, PASSWORD, REALM)
    Comment.stub!(:find).with("1").and_return(@mock_object = mock_model(Comment))
  end

  it "should render edit comment successfully" do
    Comment.should_receive(:find).with("1").and_return(@mock_object)
    get :edit, :id => "1"
    response.should be_success
    assigns(:comment).should_not be_nil
  end
end

describe Admin::CommentsController, "update comment" do

  before(:each) do
    authenticate_with_http_digest(USERNAME, PASSWORD, REALM)
    Comment.stub!(:find).with("1").and_return(@mock_object = mock_model(Comment, :update_attributes=>true))
  end

  it "should find comment successfully" do
    Comment.should_receive(:find).with("1").and_return(@mock_object)
    put :update, :id => "1", :comment=>{}
  end

  it "should update comment attributes successfully" do
    @mock_object.should_receive(:update_attributes).and_return(true)
    put :update, :id => "1", :comment=>{}
  end

  it "should have response with redirect" do
    put :update, :id => "1", :comment=>{}
    response.should be_redirect
  end

  it "should set flash notice" do
    put :update, :id => "1", :comment=>{}
    flash[:notice].should == 'Comment was updated successfully'
  end

  it "should have response with redirect to the admin comments path" do
    put :update, :id => "1", :comment=>{}
    response.should redirect_to(admin_comment_url(@mock_object))
  end
end

describe Admin::CommentsController, "update comment with invalid params" do

  before(:each) do
    authenticate_with_http_digest(USERNAME, PASSWORD, REALM)
    Comment.stub!(:find).with("1").and_return(@mock_object = mock_model(Comment, :update_attributes=>false))
  end

  it "should find comment successfully" do
    Comment.should_receive(:find).with("1").and_return(@mock_object)
    put :update, :id => "1", :comment=>{}
  end

  it "should not update the comment attributes" do
    @mock_object.should_receive(:update_attributes).and_return(false)
    put :update, :id => "1", :comment=>{}
  end

  it "response should render edit action" do
    put :update, :id => "1", :comment=>{}
    response.should render_template("edit")
  end
end

describe Admin::CommentsController, "delete comment" do

  before(:each) do
    authenticate_with_http_digest(USERNAME, PASSWORD, REALM)
    Comment.stub!(:find).with("1").and_return(@mock_object = mock_model(Comment))
  end

  it "should render new comment successfully" do
    Comment.should_receive(:find).with("1").and_return(@mock_object)
    get :delete, :id => "1"
    response.should be_success
    assigns(:comment).should_not be_nil
  end
end

describe Admin::CommentsController, "destroy comment" do

  before(:each) do
    authenticate_with_http_digest(USERNAME, PASSWORD, REALM)
    Comment.stub!(:find).with("1").and_return(@mock_object = mock_model(Comment, :destroy => true))
  end

  it "should find comment successfully" do
    Comment.should_receive(:find).with("1").and_return(@mock_object)
    delete :destroy, :id => "1"
  end

  it "should destroy comment successfully" do
    @mock_object.should_receive(:destroy).and_return(true)
    delete :destroy, :id => "1"
  end

  it "should set flash notice" do
    delete :destroy, :id => "1"
    flash[:notice].should == 'Comment was deleted successfully'
  end

  it "response should be redirect" do
    delete :destroy, :id => "1"
    response.should be_redirect
  end

  it "should redirect to the admin comment path" do
    delete :destroy, :id => "1"
    response.should redirect_to(admin_comments_url)
  end
end


describe Admin::CommentsController, "destroy multiple comment" do
  before(:each) do
    authenticate_with_http_digest(USERNAME, PASSWORD, REALM)
    Comment.stub!(:destroy)
  end

  it "should redirect if comment_ids is blank" do
    delete :destroy_multiple, :comment_ids => ""
    response.should redirect_to(admin_comments_url)
  end

  it "should call destoy with comment_ids" do
    Comment.should_receive(:destroy).with(['1', '2'])
    delete :destroy_multiple, :comment_ids => ['1', '2']
  end

  it "should set flash notice" do
    delete :destroy_multiple, :comment_ids => ['1', '2']
    flash[:notice].should == 'Comments were deleted successfully'
  end

  it "should redirect to the admin comment path" do
    delete :destroy_multiple, :comment_ids => ['1', '2']
    response.should redirect_to(admin_comments_url)
  end
end


describe Admin::CommentsController, "approve comment" do
  before(:each) do
    authenticate_with_http_digest(USERNAME, PASSWORD, REALM)
    Comment.stub!(:find).with("1").and_return(@mock_object = mock_model(Comment))
    @mock_object.stub!(:mark_as_ham!).and_return(true)
  end

  it "should find comment successfully" do
    Comment.should_receive(:find).with("1").and_return(@mock_object)
    put :approve, :id => "1", :comment=>{}
  end

  it "should mark as ham comment" do
    @mock_object.should_receive(:mark_as_ham!).and_return(true)
    put :approve, :id => "1", :comment=>{}
  end

  it "should have response with redirect" do
    put :approve, :id => "1", :comment=>{}
    response.should be_redirect
  end

  it "should set flash notice" do
    put :approve, :id => "1", :comment=>{}
    flash[:notice].should == 'Comment was approved successfully'
  end

  it "should have response with redirect to the admin comments path" do
    put :approve, :id => "1", :comment=>{}
    response.should redirect_to(admin_comments_url)
  end
end

describe Admin::CommentsController, "reject comment" do
  before(:each) do
    authenticate_with_http_digest(USERNAME, PASSWORD, REALM)
    Comment.stub!(:find).with("1").and_return(@mock_object = mock_model(Comment))
    @mock_object.stub!(:mark_as_spam!).and_return(true)
  end

  it "should find comment successfully" do
    Comment.should_receive(:find).with("1").and_return(@mock_object)
    put :reject, :id => "1", :comment=>{}
  end

  it "should mark as spam comment" do
    @mock_object.should_receive(:mark_as_spam!).and_return(true)
    put :reject, :id => "1", :comment=>{}
  end

  it "should have response with redirect" do
    put :reject, :id => "1", :comment=>{}
    response.should be_redirect
  end

  it "should set flash notice" do
    put :reject, :id => "1", :comment=>{}
    flash[:notice].should == 'Comment was rejected successfully'
  end

  it "should have response with redirect to the admin comments path" do
    put :reject, :id => "1", :comment=>{}
    response.should redirect_to(admin_comments_url)
  end
end
