namespace :youtube do
  desc "Pulling the daily list of Songs"
  task refresh: :environment do
    require 'youtube'
    youtube = YouTube.new
    youtube.search_songs()
  end
end
