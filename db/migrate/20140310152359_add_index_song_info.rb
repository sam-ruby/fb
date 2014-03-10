class AddIndexSongInfo < ActiveRecord::Migration
  def change
    add_index(:song_infos, :video_id, {name: 'video_id_idx', unique: true})
  end
end
