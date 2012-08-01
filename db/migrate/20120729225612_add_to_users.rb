class AddToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :username, :string
    add_column :users, :twitter_id, :string
    add_column :users, :facebook_id, :string

    add_index :users, :username, :unique => true
    add_index :users, :name
  end
end
