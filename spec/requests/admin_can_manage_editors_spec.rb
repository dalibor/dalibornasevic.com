require 'spec_helper'

describe "Admin" do
  let(:admin) { create :admin }

  before :each do
    login admin
  end

  it "can manage editors" do
    click_link "Editors"
    click_link "New"
    fill_in "Name", with: "New Editor"
    fill_in "Email", with: "new.editor@gmail.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_button "Save"
    page.should have_content "Editor was successfully created"
    page.should have_content "New Editor"

    click_link "Edit"
    fill_in "Name", with: "New Editor 2"
    click_button "Save"
    page.should have_content "New Editor 2"

    click_link "Delete"
    page.should have_content "Editor was successfully destroyed"
    page.should_not have_content "New Editor 2"
  end
end
