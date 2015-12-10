class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :key, :limit => 17
      t.timestamps
      t.index :key
    end
  end
end
