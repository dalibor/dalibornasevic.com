class AddCommentsCountToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :comments_count, :integer, :default => 0
    Post.reset_column_information

    Post.all.each do |post|
      Post.update_counters post.id, :comments_count => post.comments.length # size uses counter cache column
    end
  end

  def self.down
    remove_column :posts, :comments_count
  end
end
