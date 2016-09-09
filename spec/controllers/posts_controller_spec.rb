require 'spec_helper'

describe PostsController, :type => :controller do
  render_views

  describe "#index" do
    it "renders index.html" do
      get :index
      expect(response).to be_success
      expect(response.body).to include('Post 1')
      expect(response.body).to include('Post 2')
    end

    it "filters posts by year" do
      get :index, year: 2015
      expect(response).to be_success
      expect(response.body).to include('Post 1')
      expect(response.body).not_to include('Post 2')
    end

    it "filters posts by tag" do
      get :index, tag: 'tag1'
      expect(response).to be_success
      expect(response.body).to include('Post 1')
      expect(response.body).not_to include('Post 2')
    end

    it "renders index.rss" do
      get :index, format: :rss
      expect(response).to be_success
    end
  end

  describe "#show" do
    it "renders show.html" do
      get :show, id: Post.all.first.to_param
      expect(response).to be_success
      expect(response.body).to include('Post 1')
    end
  end
end
