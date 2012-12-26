class RemoveCommentsCountFromPosts < ActiveRecord::Migration
  def up
    remove_column :posts, :comments_count
  end

  def down
    add_column :posts, :comments_count, :integer
  end
end
