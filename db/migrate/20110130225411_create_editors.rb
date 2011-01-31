class CreateEditors < ActiveRecord::Migration
  def self.up
    create_table :editors do |t|
      t.string :email
      t.string :name
      t.string :password_hash
      t.string :password_salt
      t.boolean :is_admin, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :editors
  end
end
