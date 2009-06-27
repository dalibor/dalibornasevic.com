class AddIndexToCommentsPostId < ActiveRecord::Migration
  def self.up
    add_index :comments, :post_id
  end

  def self.down
    remove_index :comments, :post_id
  end
end
