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
  end

  describe 'validations' do
    subject { Factory(:editor) }
    it { should be_valid }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }

    it "validate confirmation of password" do
      editor = Factory.build(:editor, :password => 'password',
                             :password_confirmation => 'password2')
      editor.should_not be_valid
      editor.errors[:password].should include("doesn't match confirmation")
    end

    it "should validate presence of password on create" do
      editor = Factory.build(:editor, :password => nil)
      editor.should_not be_valid
      editor.errors[:password].should include("can't be blank")
    end

    it "should not validate presence of password on update" do
      editor = Factory.create(:editor)
      editor.update_attributes(:name => "New name")
      editor.save
      editor.should be_valid
    end
  end

  describe "callbacks" do
    describe "password encryption" do
      it "encrypts password on save" do
        BCrypt::Engine.should_receive(:generate_salt).and_return("$2a$10$SfbTYlR2xJX/x48XMxNXLu")
        editor = Factory.build(:editor)
        editor.password_hash.should be_nil
        editor.save
        editor.password_hash.should == "$2a$10$SfbTYlR2xJX/x48XMxNXLuim36E5WnPTcNReIz1lQfZVrIhVuBQsi"
      end
    end
  end

  describe "authenticate" do
    it "should authenticate given valid email and password" do
      editor = Factory.create(:editor)
      Editor.authenticate('pink.panter@gmail.com', 'password').should == editor
    end

    it "should not authenticate given invalid password" do
      editor = Factory.create(:editor)
      Editor.authenticate('pink.panter@gmail.com', 'password1').should == nil
    end

    it "should not authenticate given invalid email" do
      editor = Factory.create(:editor)
      Editor.authenticate('pink.panter@gmail.com1', 'password').should == nil
    end
  end

end

# == Schema Information
#
# Table name: editors
#
#  id            :integer(4)      not null, primary key
#  email         :string(255)
#  name          :string(255)
#  password_hash :string(255)
#  password_salt :string(255)
#  is_admin      :boolean(1)      default(FALSE)
#  created_at    :datetime
#  updated_at    :datetime
#

