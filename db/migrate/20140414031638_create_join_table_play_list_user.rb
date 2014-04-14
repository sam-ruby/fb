class CreateJoinTablePlayListUser < ActiveRecord::Migration
  def change
    create_join_table :play_lists, :users do |t|
      t.index [:play_list_id, :user_id]
      # t.index [:user_id, :play_list_id]
    end
  end
end
