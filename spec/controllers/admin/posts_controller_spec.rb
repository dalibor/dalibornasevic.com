require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::PostsController do

  before(:each) do
    @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("dalibor:password")
  end

  # cound be implemented this way,
  # but cucumber do integration testing and this is not needed
  describe "responding to GET /admin/posts" do
    it "should be sucess" do
      Post.stub!(:paginate)
      get :index
      response.should be_success
      assigns(:posts).should_not be_nil
    end
  end


end
