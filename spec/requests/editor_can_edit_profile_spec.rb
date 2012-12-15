require 'spec_helper'

describe "Editor" do
  let(:editor) { create :editor }

  before :each do
    login editor
  end

  it "can edit profile" do
    click_link "Profile"
    fill_in "Name", with: "My new name"
    fill_in "Email", with: "my_new_email@gmail.com"
    fill_in "Password", with: "password2"
    fill_in "Password confirmation", with: "password2"
    click_button "Save"
    page.should have_content "Profile was successfully updated"

    click_link "Logout"
    fill_in "Email", with: "my_new_email@gmail.com"
    fill_in "Password", with: "password2"
    click_button "Login"
    page.should have_content "Logged in!"
  end
end
