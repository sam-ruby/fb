class User < ActiveRecord::Base
  has_many :play_lists
end
