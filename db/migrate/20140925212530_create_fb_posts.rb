class CreateFbPosts < ActiveRecord::Migration
  def change
    create_table :fb_posts do |t|
      t.string :post_id
      t.datetime :post_created
      t.string :type
      t.string :video_id
    end
  end
end
