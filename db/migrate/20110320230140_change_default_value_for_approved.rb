class ChangeDefaultValueForApproved < ActiveRecord::Migration
  def self.up
    change_column :comments, :approved, :boolean, :default => true, :null => false
  end

  def self.down
    change_column :comments, :approved, :boolean, :default => false, :null => false
  end
end
