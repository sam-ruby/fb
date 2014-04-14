class CreatePlayLists < ActiveRecord::Migration
  def change
    create_table :play_lists do |t|
      t.string :name
      t.text :description
      t.integer :user_id

      t.timestamps
    end
  end
end
