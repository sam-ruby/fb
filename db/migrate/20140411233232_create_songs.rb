class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :fb_post_id
      t.datetime :fb_created_time
      t.datetime :fb_updated_time
      t.string :video_id
      t.datetime :published_at
      t.string :channel_id
      t.text :title
      t.text :description
      t.string :image_url
      t.string :channel_title
    end
    add_index :songs, :fb_post_id, unique: true
    add_index :songs, :fb_updated_time
    add_index :songs, :fb_created_time
  end
end
