require 'spec_helper'

describe Admin::EditorsController do

  context "admin" do
    before :each do
      login_as_admin
      @editor_mock = mock_model(Editor)
      Editor.stub_chain(:find).and_return(@editor_mock)
      Editor.stub_chain(:find, :update_attributes).and_return(true)
      Editor.stub_chain(:find, :destroy).and_return(true)
      Editor.stub_chain(:build).and_return(@editor_mock)
    end

    context "index" do
      before do get :index end
      it_should_behave_like "accessible resource"
    end

    context "new" do
      before do get :new end
      it_should_behave_like "accessible resource"
    end

    context "show" do
      before do get :show, :id => 1 end
      it_should_behave_like "accessible resource"
    end

    context "create" do
      before do post :create end
      it_should_behave_like "accessible resource"
    end

    context "update" do
      before do put :update, :id => 1 end
      it_should_behave_like "accessible resource"
    end

    context "destroy" do
      before do delete :destroy, :id => 1 end
      it_should_behave_like "accessible resource"
    end
  end

  context "editor" do
    before :each do
      login_as_editor
    end

    context "index" do
      before do get :index end
      it_should_behave_like "protected resource"
    end

    context "new" do
      before do get :new end
      it_should_behave_like "protected resource"
    end

    context "show" do
      before do get :show, :id => 1 end
      it_should_behave_like "protected resource"
    end

    context "create" do
      before do post :create end
      it_should_behave_like "protected resource"
    end

    context "update" do
      before do put :update, :id => 1 end
      it_should_behave_like "protected resource"
    end

    context "destroy" do
      before do delete :destroy, :id => 1 end
      it_should_behave_like "protected resource"
    end
  end
end
