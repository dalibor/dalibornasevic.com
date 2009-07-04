class AddPublishedAtToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :published_at, :timestamp
    
    Post.reset_column_information
    Post.all.each do |post|
      post.update_attribute(:published_at, post.created_at)
    end
  end

  def self.down
    remove_column :posts, :published_at
  end
end
