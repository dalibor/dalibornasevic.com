require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::PostsController, "list posts" do
  
  before(:each) do
    @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("dalibor:password")
    Post.stub!(:paginate).and_return(@mock_objects = [mock_model(Post)])
  end
  
  it "should render list of posts successfully" do
    Post.should_receive(:paginate).and_return([@mock_objects])
    get :index
    response.should be_success
    assigns(:posts).should_not be_nil
  end
end

describe Admin::PostsController, "new post" do
  
  before(:each) do
    @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("dalibor:password")
    Post.stub!(:new).and_return(@mock_object = mock_model(Post))
  end
  
  it "should render new post successfully" do
    Post.should_receive(:new).with().and_return(@mock_object)
    get :new
    response.should be_success
    assigns(:post).should_not be_nil
  end
end

describe Admin::PostsController, "new post create valid" do
  
  before(:each) do
    @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("dalibor:password")
    Post.stub!(:new).and_return(@mock_object = mock_model(Post, :save=>true))
  end
  
  it "should create new post successfully" do
    Post.should_receive(:new).with("name"=>"value").and_return(@mock_object)
    post :create, :post=>{:name=>"value"}
  end
  
  it "should save the post successfully" do
    @mock_object.should_receive(:save).and_return(true)
    post :create, :post=>{:name=>"value"}
#    assigns[:post].should_not be_new_record
  end
  
  it "response should be redirect" do
    post :create, :post=>{:name=>"value"}
    response.should be_redirect
  end
  
  it "should assign post" do
    post :create, :post=>{:name=>"value"}
    assigns(:post).should == @mock_object
  end
  
  it "should redirect to the admin post path" do
    post :create, :post=>{:name=>"value"}
    response.should redirect_to(admin_post_url(@mock_object))
  end
end

describe Admin::PostsController, "new post create invalid" do
  
  before(:each) do
    @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("dalibor:password")
    Post.stub!(:new).and_return(@mock_object = mock_model(Post, :save=>false))
  end
  
  it "should create new post successfully" do
    Post.should_receive(:new).with("name"=>"value").and_return(@mock_object)
    post :create, :post=>{:name=>"value"}
  end
  
  it "should not save the post" do
    @mock_object.should_receive(:save).and_return(false)
    post :create, :post=>{:name=>"value"}
  end
  
  it "response should be success" do
    post :create, :post=>{:name=>"value"}
    response.should be_success
  end
  
  it "should assign post" do
    post :create, :post=>{:name=>"value"}
    assigns(:post).should == @mock_object
  end
  
  it "should render new action" do
    post :create, :post=>{:name=>"value"}
    response.should render_template("new")
  end
end

describe Admin::PostsController, "edit post" do
  
  before(:each) do
    @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("dalibor:password")
    Post.stub!(:find).with("1").and_return(@mock_object = mock_model(Post))
  end
  
  it "should render edit post successfully" do
    Post.should_receive(:find).with("1").and_return(@mock_object)
    get :edit, :id => "1"
    response.should be_success
    assigns(:post).should_not be_nil
  end
end

describe Admin::PostsController, "update post with valid params" do
  
  before(:each) do
    @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("dalibor:password")
    Post.stub!(:find).with("1").and_return(@mock_object = mock_model(Post, :update_attributes=>true))
  end
  
  it "should find post successfully" do
    Post.should_receive(:find).with("1").and_return(@mock_object)
    put :update, :id => "1", :post=>{}
  end
  
  it "should update post attributes successfully" do
    @mock_object.should_receive(:update_attributes).and_return(true)
    put :update, :id => "1", :post => {}
  end

  it "response should be redirect" do
    put :update, :id => "1", :post=>{}
    response.should be_redirect
  end
  
  it "should assign post" do
    put :update, :id => "1", :post=>{}
    assigns(:post).should == @mock_object
  end
  
  it "should redirect to the admin post path" do
    put :update, :id => "1", :post=>{}
    response.should redirect_to(admin_post_url(@mock_object))
  end

end

describe Admin::PostsController, "update post with invalid params" do
  
  before(:each) do
    @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("dalibor:password")
    Post.stub!(:find).with("1").and_return(@mock_object = mock_model(Post, :update_attributes=>false))
  end
  
  it "should find post successfully" do
    Post.should_receive(:find).with("1").and_return(@mock_object)
    put :update, :id => "1", :post=>{}
  end
  
  it "should not update the post attributes" do
    @mock_object.should_receive(:update_attributes).and_return(false)
    put :update, :id => "1", :post => {}
  end

  it "response should render edit action" do
    put :update, :id => "1", :post=>{}
    response.should render_template("edit")
  end

describe Admin::PostsController, "delete post" do
  
  before(:each) do
    @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("dalibor:password")
    Post.stub!(:find).with("1").and_return(@mock_object = mock_model(Post))
  end
  
  it "should render delete post successfully" do
    Post.should_receive(:find).with("1").and_return(@mock_object)
    get :edit, :id => "1"
    response.should be_success
    assigns(:post).should_not be_nil
  end
end

describe Admin::PostsController, "destroy post" do
  
  before(:each) do
    @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("dalibor:password")
    Post.stub!(:find).with("1").and_return(@mock_object = mock_model(Post, :destroy => true))
  end
  
  it "should destroy post successfully" do
    @mock_object.should_receive(:destroy).and_return(true)
    delete :destroy, :id => "1"
  end
  
  it "response should be redirect" do
    delete :destroy, :id => "1"
    response.should be_redirect
  end
  
  it "should redirect to the admin post path" do
    delete :destroy, :id => "1"
    response.should redirect_to(admin_posts_path)
  end
end

end