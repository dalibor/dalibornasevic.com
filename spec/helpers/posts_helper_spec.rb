require 'spec_helper'

describe PostsHelper do

  it "returns posts title" do
    posts_title.should == "All Blog Posts"
  end

  it "returns posts title for tag" do
    params[:tag] = 'ruby'
    posts_title.should == "Tagged with ruby"
  end

  it "returns posts title for year" do
    params[:year] = '2014'
    posts_title.should == "Written in 2014"
  end
end
