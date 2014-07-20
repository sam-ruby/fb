class SongsController < ApplicationController
  def index
    per_page = params[:per_page].to_i
    per_page = per_page == 0 ? 20 : per_page
    page = params[:page].to_i
    offset = page * per_page - per_page
    total_songs = params[:total_songs]
    if !total_songs
      total_songs = Song.all.size
    end
    respond_to do |format|
      format.html do
        render
      end

      format.json do
        render :json => {
          total_songs: total_songs,
          songs: Song.all.order(published_at: :desc).limit(
            per_page).offset(offset)
        }
      end
    end
  end
end
