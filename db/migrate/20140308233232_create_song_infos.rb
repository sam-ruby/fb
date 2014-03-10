class CreateSongInfos < ActiveRecord::Migration
  def change
    create_table :song_infos do |t|
      t.string :video_id
      t.datetime :published_at
      t.string :channel_id
      t.text :title
      t.text :description
      t.string :image_url
      t.string :channel_title
      t.timestamps
    end
  end
end
