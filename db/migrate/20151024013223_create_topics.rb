class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.integer :key, :limit => 8
      t.timestamps
      t.index :key
    end
  end
end
