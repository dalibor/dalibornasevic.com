require 'spec_helper'

describe "Visitor", :type => :request do

  it "can view posts" do
    visit posts_path
    expect(page).to have_content("Post 1")
    expect(page).to have_content("Post 2")
  end

  it "can view a single post" do
    visit posts_path
    click_link "Post 1"
    expect(page).to have_content("Post 1")
    expect(page).not_to have_content("Post 2")
  end

  it "can see posts grouped by year" do
    visit posts_path
    expect(page).to have_content("2016 (1)")
    expect(page).to have_content("2015 (1)")
    click_link "2015"
    expect(page).to have_content("Post 1")
    expect(page).not_to have_content("Post 2")
  end
end
