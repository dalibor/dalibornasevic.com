class AddEditorIdToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :editor_id, :integer
  end

  def self.down
    remove_column :posts, :editor_id
  end
end
