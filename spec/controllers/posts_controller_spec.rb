require 'spec_helper'

describe PostsController, "list posts" do
  describe "index posts" do
    it "should render list of posts successfully" do
      Post.stub_chain(:order, :includes, :where, :paginate).and_return(@mock_objects = [mock_model(Post)])
      get :index
      response.should be_success
      assigns(:posts).should_not be_nil
    end

    it "should render list of posts successfully when :tag param is present" do
      tag = 'tag 1'

      Tag.stub(:find_by_name).with(tag).and_return(@tag_mock = mock_model(Tag))
      @tag_mock.stub_chain(:posts, :order, :includes, :where, :paginate => (@posts_mock = [mock_model(Post)]))

      Tag.should_receive(:find_by_name).with(tag).and_return(@tag_mock)
      @tag_mock.should_receive(:posts)

      get :index, :tag => tag

      response.should be_success
      assigns(:posts).should_not be_nil
    end

    it "should render list of posts successfully when :tag param is present but tag is not found" do
      tag = 'tag 1'
      Tag.stub(:find_by_name).with(tag).and_return(nil)
      Post.stub_chain(:order, :includes, :where, :paginate).and_return(@posts_mock = [mock_model(Post)])

      Post.should_receive(:order)

      get :index, :tag => tag

      response.should be_success
      assigns(:posts).should_not be_nil
    end
  end


  describe "show post" do
    before :each do
      @post_mock     = mock_model(Post)

      Post.stub_chain(:where, :find).and_return(@post_mock)
    end

    it "should render single post successfully" do
      @chain = mock(:relation)
      Post.should_receive(:where).and_return(@chain)
      @chain.should_receive(:find).and_return(@post_mock)
      get :show, :id => '1'
      assigns(:post).should_not be_nil
      response.should be_success
    end
  end
end
