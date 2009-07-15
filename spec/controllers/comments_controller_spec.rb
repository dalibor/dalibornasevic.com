require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CommentsController, "create valid comment" do
  before(:each) do
    Post.stub!(:find).and_return(@post_mock = mock_model(Post))
#    Post.stub!(:find).with("1").and_return(@post_mock = mock_model(Post))
    request.session[:spam_timestamp] = (Time.now-15.seconds).to_i
    @post_mock.stub_association!(:comments, :new => (@comment_mock = mock_model(Comment, :save => true)))
  end
  
  it "should find post" do
    Post.should_receive(:find).and_return(@post_mock)
    post :create, :post_id => "1", :comment=>{:name=>"value"}
  end
  
#  it "should initialize new comment successfully" do
#    Post.stub!(:find).with("1").and_return(@post_mock = mock_model(Post))
#    @post_mock.stub_association!(:comments, :new => (@comment_mock = mock_model(Comment, :save => true)))
#    
#    Post.should_receive(:find).and_return(@post_mock)
#    @post_mock.comments.should_receive(:new).and_return(@comment_mock)
#    @comment_mock.should_receive(:save).and_return(true)
#    post :create, :post_id => "1", :comment=>{:name=>"value"}
#  end
  
  it "should initialize new comment successfully" do
    Post.should_receive(:find).and_return(@post_mock)
    @post_mock.comments.should_receive(:new).and_return(@comment_mock)
    post :create, :post_id => "1", :comment=>{:name=>"value"}
  end
  
  it "should save the comment successfully" do
    @comment_mock.should_receive(:save).and_return(true)
    post :create, :post_id => "1", :comment=>{:name=>"value"}
  end
  
  it "should have response with redirect" do
    post :create, :post_id => "1", :comment=>{:name=>"value"}
    response.should be_redirect
  end

  it "should redirect to post path" do
    post :create, :post_id => "1", :comment=>{:name=>"value"}
    response.should redirect_to(post_path(@post_mock))
  end
  
  it "should display flash notice" do
    post :create, :post_id => "1", :comment=>{:name=>"value"}
    flash[:notice].should == "Your comment was successfully created."
  end
end

describe CommentsController, "try to create invalid comment" do
  
  before(:each) do
    Post.stub!(:find).and_return(@post_mock = mock_model(Post))
    request.session[:spam_timestamp] = (Time.now-15.seconds).to_i
    @post_mock.stub_association!(:comments, :new => (@comment_mock = mock_model(Comment, :save => false)))
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
end
