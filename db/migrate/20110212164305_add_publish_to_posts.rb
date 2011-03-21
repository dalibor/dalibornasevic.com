class AddPublishToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :publish, :boolean, :default => false
  end

  def self.down
    remove_column :posts, :publish
  end
end
