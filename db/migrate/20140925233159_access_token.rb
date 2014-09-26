class AccessToken < ActiveRecord::Migration
  def change
    create_table :access_token do |t|
      t.string :token
    end
  end
end
