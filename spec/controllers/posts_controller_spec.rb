require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PostsController do
  
  it "should render list of posts successfully" do
    # controller.should be_an_instance_of(PostsController)
    post = mock_model(Post)
#    Post.stub!(:paginate).and_return([post])
    Post.should_receive(:paginate).and_return([post])
    get :index
    response.should be_success
    assigns(:posts).should_not be_nil
  end
  
  it "should render single post successfully" do
    post = mock_model(Post)
    Post.should_receive(:find).and_return(post)
    get :show, :id => '1'
    response.should be_success
  end
  
end