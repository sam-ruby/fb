class PlayListsController < ApplicationController
  def index
    user_id  = 1 if (user_id = params[:user_id].to_i) == 0
    user = User.find(user_id)
    respond_to do |format|
      format.json do
        render :json => user.play_lists.order(
          updated_at: :desc).limit(10)
      end
    end
  end
end
