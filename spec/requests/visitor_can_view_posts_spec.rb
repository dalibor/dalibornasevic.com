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

  it "can see posts grouped by year" do
    create(:post, title: "Cucumber", published_at: "2013-02-03")
    create(:post, title: "Webrat", published_at: "2013-01-13")
    create(:post, title: "Vim", published_at: "2012-02-03")
    visit posts_path
    page.should have_content "2013 (2)"
    page.should have_content "2012 (1)"
    page.should have_content "Cucumber"
    page.should have_content "Webrat"
    page.should have_content "Vim"
    click_link "2013"
    page.should have_content "Cucumber"
    page.should have_content "Webrat"
    page.should_not have_content "Vim"
  end
end
