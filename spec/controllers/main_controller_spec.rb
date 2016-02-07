require 'spec_helper'

describe MainController, :type => :controller do
  render_views

  describe "#index" do
    it "renders index.html" do
      get :index
      expect(response).to be_success
      expect(response.body).to include('Post 1')
      expect(response.body).to include('Post 2')
    end
  end

  describe "#sitemap" do
    it "renders sitempa.xml" do
      get :index
      expect(response).to be_success
    end
  end
end
