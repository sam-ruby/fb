class HomeController < ApplicationController
  skip_before_action :verify_authenticity_token
  App_id = 505033162966353
  App_Secret = '59541647ebdefd2c93e4c7ea48608c36'
  Callback_Url = 'https://www.rightmoveltd.com/'
  @@oauth = Koala::Facebook::OAuth.new(App_id, App_Secret, Callback_Url)

  def store_tokens
    envelope = @@oauth.parse_signed_request( params['signed_request'] )
    oauth_token = envelope['oauth_token']
    user_id = envelope['user_id']
    if user_id == '10152755346287948'
      logger.info 'Exchanging for long lasting token ' + oauth_token
      oauth_token = @@oauth.exchange_access_token(oauth_token)
      record = AccessToken.first
      if record.nil?
        AccessToken.create(token: oauth_token)
        logger.info 'Token Created'
      else
        record.token = oauth_token
        record.save
        logger.info 'Token saved'
      end
    end
    redirect_to '/'
  end
end
