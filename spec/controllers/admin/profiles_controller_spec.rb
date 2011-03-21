require 'spec_helper'

describe Admin::ProfilesController do
  before :each do
    @editor_mock = mock_model(Editor)
    login_as_editor
  end

  it "assigns editor on edit" do
    controller.should_receive(:current_editor).and_return(@editor_mock)
    get :edit
    assigns(:editor).should_not be_nil
  end

  it "assigns editor on update" do
    controller.should_receive(:current_editor).and_return(@editor_mock)
    @editor_mock.should_receive(:update_attributes).and_return(true)
    put :update
    assigns(:editor).should_not be_nil
  end
end
