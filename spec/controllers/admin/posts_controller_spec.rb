require 'spec_helper'

describe Admin::PostsController do
  before :each do
    @current_editor = login_as_editor # gives @current_editor variable
    @post_mock = mock_model(Post)
  end

  # NOTE: inherit_resources is already tested, we just check
  # if all methods scope the posts by the current editor

  describe "index posts" do
    it "should render list of posts successfully" do
      @current_editor.stub_chain(:posts, :order, :paginate).and_return([@post_mock])
      get :index
      response.should be_success
    end
  end

  describe "show post" do
    it "should render new post successfully" do
      @current_editor.stub_chain(:posts, :find).with("1").and_return(@post_mock)
      get :show, :id => "1"
      response.should be_success
    end
  end

  describe "new post" do
    it "should render new post successfully" do
      @current_editor.stub_chain(:posts, :build).and_return(@post_mock)
      get :new
      response.should be_success
    end
  end

  describe "create post" do
    it "should have response with redirect" do
      @current_editor.stub_chain(:posts, :build).and_return(@post_mock)
      @post_mock.stub(:save).and_return(true)
      post :create, :post => {:name => "value"}
      response.should be_redirect
    end
  end

  describe "edit post" do
    it "should render edit post successfully" do
      @current_editor.stub_chain(:posts, :find).with("1").and_return(@post_mock)
      get :edit, :id => "1"
      response.should be_success
    end
  end

  describe "create post" do
    it "should have response with redirect" do
      @current_editor.stub_chain(:posts, :find).and_return(@post_mock)
      @post_mock.stub(:update_attributes).and_return(true)
      put :update, :id => "1", :post => {}
      response.should be_redirect
    end
  end

  describe "destroy post" do
    it "response should be redirect" do
      @current_editor.stub_chain(:posts, :find).and_return(@post_mock)
      @post_mock.stub(:destroy).and_return(true)
      delete :destroy, :id => "1"
      response.should be_redirect
    end
  end
end
