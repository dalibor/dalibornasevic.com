def login_as_editor
  current_editor = Factory.create(:editor, :email => "editor@example.com")
  controller.stub!(:current_editor).and_return(current_editor)
  controller.stub!(:authenticate).and_return(:true)
  current_editor
end

def login_as_admin
  current_editor = Factory.create(:admin, :email => "admin@example.com")
  controller.stub!(:current_editor).and_return(current_editor)
  controller.stub!(:authenticate).and_return(:true)
  current_editor
end
