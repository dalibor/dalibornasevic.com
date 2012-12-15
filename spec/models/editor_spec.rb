require 'spec_helper'

describe Editor do

  describe 'attributes' do
    it { should allow_mass_assignment_of(:email) }
    it { should allow_mass_assignment_of(:name) }
    it { should allow_mass_assignment_of(:password) }
    it { should allow_mass_assignment_of(:password_confirmation) }
  end

  describe 'associations' do
    it { should have_many(:posts) }
    it { should have_many(:attachments) }
  end

  describe 'validations' do
    subject { create(:editor) }
    it { should be_valid }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }

    it "validate confirmation of password" do
      editor = build(:editor, :password => 'password',
                             :password_confirmation => 'password2')
      editor.should_not be_valid
      editor.errors[:password].should include("doesn't match confirmation")
    end

    it "should validate presence of password on create" do
      editor = build(:editor, :password => nil)
      editor.should_not be_valid
      editor.errors[:password].should include("can't be blank")
    end

    it "should not validate presence of password on update" do
      editor = create(:editor)
      editor.update_attributes(:name => "New name")
      editor.save
      editor.should be_valid
    end
  end

  describe "callbacks" do
    describe "password encryption" do
      it "encrypts password on save" do
        BCrypt::Engine.should_receive(:generate_salt).and_return("$2a$10$SfbTYlR2xJX/x48XMxNXLu")
        editor = build(:editor)
        editor.password_hash.should be_nil
        editor.save
        editor.password_hash.should == "$2a$10$SfbTYlR2xJX/x48XMxNXLuim36E5WnPTcNReIz1lQfZVrIhVuBQsi"
      end
    end
  end

  describe "authenticate" do
    it "should authenticate given valid email and password" do
      editor = create(:editor, :email => 'pink.panter@gmail.com')
      Editor.authenticate('pink.panter@gmail.com', 'password').should == editor
    end

    it "should not authenticate given invalid password" do
      editor = create(:editor)
      Editor.authenticate('pink.panter@gmail.com', 'password1').should == nil
    end

    it "should not authenticate given invalid email" do
      editor = create(:editor)
      Editor.authenticate('pink.panter@gmail.com1', 'password').should == nil
    end
  end
end
