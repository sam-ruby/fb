class SongController < ApplicationController

  def get_list
    respond_to do |format|
      format.json do render :json => Song.all.order(created_at: :desc) end
    end
  end
end
