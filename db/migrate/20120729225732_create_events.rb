class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :user_id, :null => false
      t.text :name, :null => false
      t.date :eventDate, :null => false
      t.text :comment, :default => "", :null => false
      t.text :eventType, :null => false

      t.timestamps
    end

    add_index :events, :user_id
    add_index :events, :name
    add_index :events, :eventDate
    add_index :events, :comment
    add_index :events, :eventType
  end
end
