class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :user_id, :null => false
      t.text :name, :null => false
      t.integer :date, :null => false
      t.text :comment, :default => "", :null => false

      t.timestamps
    end

    add_index :events, :user_id
    add_index :events, :name
    add_index :events, :date
    add_index :events, :comment
  end
end
