require 'spec_helper'

describe Admin::EditorsController do

  describe "protect pages from editor" do
    before :each do
      login
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

    #context "new" do
    #end

  end
end
