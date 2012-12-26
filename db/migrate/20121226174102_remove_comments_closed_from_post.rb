class RemoveCommentsClosedFromPost < ActiveRecord::Migration
  def up
    remove_column :posts, :comments_closed
  end

  def down
    add_column :posts, :comments_closed, :boolean
  end
end
