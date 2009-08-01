class AddIndexToPostIdAndTagIdInTaggingsTable < ActiveRecord::Migration
  def self.up
    add_index :taggings, :post_id
    add_index :taggings, :tag_id
  end

  def self.down
    remove_index :taggings, :post_id
    remove_index :taggings, :tag_id
  end
end
