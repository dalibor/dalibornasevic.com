class AddCommentsClosedToPost < ActiveRecord::Migration
  def self.up
    add_column :posts, :comments_closed, :boolean, :default => false
  end

  def self.down
    remove_column :posts, :comments_closed
  end
end
