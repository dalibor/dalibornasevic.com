require 'spec_helper'

describe PostsHelper, :type => :helper do

  it "returns posts title" do
    expect(posts_title).to eq("Blog posts")
  end

  it "returns posts title for tag" do
    params[:tag] = 'ruby'
    expect(posts_title).to eq("Blog posts tagged with ruby")
  end

  it "returns posts title for year" do
    params[:year] = '2014'
    expect(posts_title).to eq("Blog posts written in 2014")
  end
end
