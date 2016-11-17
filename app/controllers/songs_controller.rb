class SongsController < ApplicationController
  def index
    # testing
    per_page = params[:per_page].to_i
    per_page = per_page == 0 ? 20 : per_page
    page = params[:page].to_i
    offset = page * per_page - per_page
    respond_to do |format|
      format.json do
        render :json => Song.all.order(created_at: :desc).limit(
          per_page).offset(offset)
      end
    end
  end
end
