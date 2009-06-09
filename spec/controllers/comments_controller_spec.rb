require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CommentsController, "create valid comment" do
  before(:each) do
    controller.stub!(:find_commentable).and_return(@post_mock = mock_model(Post))
#    Post.stub!(:find).with("1").and_return(@post_mock = mock_model(Post))
    @post_mock.stub_association!(:comments, :new => (@comment_mock = mock_model(Comment, :save => true)))
  end
  
  it "should find commentable" do
    controller.should_receive(:find_commentable).and_return(@post_mock)
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
    controller.should_receive(:find_commentable).and_return(@post_mock)
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

  it "should redirect to commentable path" do
    post :create, :post_id => "1", :comment=>{:name=>"value"}
    response.should redirect_to(post_path(@post_mock))
  end
  
  it "should display flash notice" do
    post :create, :post_id => "1", :comment=>{:name=>"value"}
    flash[:notice].should == "Your comment was successfully created."
  end
  

end