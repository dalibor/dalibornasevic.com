def login_as_editor
  current_editor = create(:editor, :email => "editor@example.com")
  controller.stub!(:current_editor).and_return(current_editor)
  controller.stub!(:authenticate).and_return(:true)
  current_editor
end

def login_as_admin
  current_editor = create(:admin, :email => "admin@example.com")
  controller.stub!(:current_editor).and_return(current_editor)
  controller.stub!(:authenticate).and_return(:true)
  current_editor
end

def login(user)
  visit login_path
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Login"
end
