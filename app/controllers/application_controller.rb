class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  after_action :set_response_headers

  def set_response_headers
    response.headers['X-Frame-Options'] = '*' 
  end
end
