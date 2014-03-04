namespace :youtube do
  desc "Pulling the daily list of Songs"
  task refresh: :environment do
    require 'youtube'
    youtube = YouTube.new
    youtube.get_channel_list()
  end
end
