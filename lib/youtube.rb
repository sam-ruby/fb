class YouTube
  G_HOST = 'https://www.googleapis.com'
  G_BASE_URL = '/youtube/v3'

  def initialize
    @config_file = File.join(
      Rails.root, 'config', Rails.application.config.youtube_key_file_name) 
    raise "Config file not loaded" unless File.exist?(@config_file)
    @secrets = YAML.load(File.read(@config_file))
  end

  def authorize
    url = 'https://accounts.google.com/o/oauth2/token'
    res = Net::HTTP.post_form(URI.parse(url),
                        client_id: @secrets['client_id'],
                        client_secret: @secrets['client_secret'],
                        refresh_token: @secrets['refresh_token'],
                        grant_type: 'refresh_token')
    if res.is_a?(Net::HTTPSuccess)
      @secrets['access_token']  = JSON.parse(res.body)['access_token']
      File.write(@config_file, @secrets.to_yaml)
      Rails.logger.info('Refreshed the access token successfully')
    else
      raise "Unable to refresh the access token"
    end
  end

  def make_url(path, parts)
    "#{G_HOST}#{G_BASE_URL}/channels?" + 
      parts.map {|k,v| "#{k}=#{v}"}.join('&')
  end

  def get_channel_list
    url = make_url('channels', {
      part: 'id,snippet', mine: true,
      access_token: @secrets['access_token']})
    retried = false
    begin
      Rails.logger.info('Abt to call the url ' + url)
      res = Net::HTTP.get(URI.parse(url))
      if !res.is_a?(Net::HTTPSuccess)
        if (a = JSON.parse(res)) and 
          a['error'] and res['error']['code'] == 401
          raise 'Auth Error'
        end
      end
    rescue RuntimeError => e
      if e == 'Auth Error' and !retried
        retried = true
        authorize()
        retry
      end
    else
      puts JSON.parse(res)
    end
  end
end
