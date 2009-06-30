require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PostsController, "list posts" do
  
  it "should render list of posts successfully" do
    Post.stub!(:paginate).and_return(@mock_objects = [mock_model(Post)])
    Post.should_receive(:paginate).and_return([@mock_objects])
    get :index
    response.should be_success
    assigns(:posts).should_not be_nil
  end
  
  it "should render list of posts successfully when :tag param is present" do
    Tag.stub!(:find_by_name).with('tag 1').and_return(@tag_mock_object = mock_model(Tag))
    @tag_mock_object.stub_association!(:posts, :paginate => (@posts_mock = [mock_model(Post)]))
    
    Tag.should_receive(:find_by_name).with('tag 1').and_return(@tag_mock_object)
    @tag_mock_object.posts.should_receive(:paginate).and_return(@posts_mock)

    get :index, :tag => 'tag 1'
    response.should be_success
    assigns(:posts).should_not be_nil
  end
  
  it "should render list of posts successfully when :tag param is present but tag is not found" do
    Tag.stub!(:find_by_name).with('tag 1').and_return(nil)

    Post.stub!(:paginate).and_return(@mock_objects = [mock_model(Post)])
    Post.should_receive(:paginate).and_return([@mock_objects])

    get :index, :tag => 'tag -1'
    response.should be_success
    assigns(:posts).should_not be_nil
  end
end

describe PostsController, "show post" do
  
  before(:each) do
    Post.stub!(:find).with("1").and_return(@mock_object = mock_model(Post))
    @mock_object.stub!(:comments).and_return(@comments = [mock_model(Comment)])
    @mock_object.stub!(:comments).and_return(@comments)
  end
  
  it "should render single post successfully" do
    Post.should_receive(:find).and_return(@mock_object)
    get :show, :id => '1'
    assigns(:post).should_not be_nil
    response.should be_success
  end
  
  it "should assing comments for a post successfully" do
    @mock_object.should_receive(:comments).and_return(@comments)
    get :show, :id => '1'
    assigns(:comments).should_not be_nil
  end
end
