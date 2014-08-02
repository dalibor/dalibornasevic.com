require 'spec_helper'

describe "Visitor" do

  it "can view posts" do
    create(:post, title: "Cucumber")
    create(:post, title: "Webrat")
    visit posts_path
    page.should have_content "Cucumber"
    page.should have_content "Webrat"
  end

  it "can view a single post" do
    editor = create(:editor)
    create(:post, title: "Cucumber", editor: editor)
    create(:post, title: "Webrat", editor: editor)
    visit posts_path
    click_link "Cucumber"
    page.should have_content "Cucumber"
    page.should_not have_content "Webrat"
  end

  it "does not display unpublished posts" do
    create(:post, title: "Cucumber", published_at: nil)
    visit posts_path
    page.should_not have_content "Cucumber"
  end

  it "can see posts grouped by month" do
    create(:post, title: "Cucumber", published_at: "2011-01-03")
    create(:post, title: "Webrat", published_at: "2011-01-13")
    create(:post, title: "Vim", published_at: "2011-02-03")
    visit posts_path
    page.should have_content "January 2011 (2)"
    page.should have_content "February 2011 (1)"
    page.should have_content "Cucumber"
    page.should have_content "Webrat"
    page.should have_content "Vim"
    click_link "January 2011"
    page.should have_content "Cucumber"
    page.should have_content "Webrat"
    page.should_not have_content "Vim"
  end
end
