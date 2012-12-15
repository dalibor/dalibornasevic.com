require 'spec_helper'

describe "Editor" do
  let(:editor) { create :editor }

  before :each do
    login editor
  end

  it "can manage posts" do
    click_link "Posts"
    click_link "New"
    fill_in "Title", with: "First title"
    fill_in "Content", with: "First content"
    check "post_publish"
    fill_in "Tags", with: "tag1 tag2 tag3"
    click_button "Save"
    page.should have_content "Post was successfully created"

    click_link "Edit"
    fill_in "Title", with: "Git"
    fill_in "Content", with: "Git rules"
    click_button "Save"
    page.should have_content "Post was successfully updated"
    page.should have_content "Git"
    page.should_not have_content "Cucumber"

    click_link "Delete"
    page.should have_content "Post was successfully destroyed"
    page.should_not have_content "Git"
  end

  it "can manage only their posts" do
    create(:post, editor: editor, title: "My post")
    editor2 = create(:editor)
    create(:post, editor: editor2, title: "Other post")
    click_link "Posts"
    page.should have_content "My post"
    page.should_not have_content "Other post"
  end
end
