class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.integer :key
      t.string :title
      t.timestamps
      t.index :key
    end
  end
end
