class YouTube
  G_HOST = 'https://www.googleapis.com'
  G_BASE_URL = '/youtube/v3'

  def initialize
    Rails.logger = Logger.new(STDOUT)
    @config_file = File.join(
      Rails.root, 'config', Rails.application.config.youtube_key_file_name) 
    raise "Config file not loaded" unless File.exist?(@config_file)
    @secrets = YAML.load(File.read(@config_file))
  end

  def refresh
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
    "#{G_HOST}#{G_BASE_URL}/#{path}?" + 
      parts.reject{|k,v| v.nil?}.map {|k,v|
        "#{URI::encode(k.to_s)}=#{URI::encode(v.to_s)}"}.join('&')
  end

  def search_songs
    retried = false
    res = ''
    next_page_token=nil
    loop_count = 0
    @sum_count = 0
    @max_song_id = Song.maximum(:id) || 0
    
    while ((next_page_token.nil? and loop_count == 0) or 
      (!next_page_token.nil? and loop_count < 10) or 
      (next_page_token.nil? and loop_count != 0)) do
      loop_count += 1
      Rails.logger.info("Retried flag is #{retried}")
      begin
        url = make_url(
          'search', {part: 'snippet', mine: true, 
                     q: 'malayalam songs', maxResults: 50,
                     pageToken: next_page_token,
                     access_token: @secrets['access_token']})
        Rails.logger.info('Abt to call the url ' + url)
        res = Net::HTTP.get_response(URI.parse(url))
        if !res.is_a?(Net::HTTPSuccess)
          Rails.logger.error(JSON.parse(res.body))
          a = JSON.parse(res.body)
          if a['error'] and a['error']['code'] == 401
            raise 'Auth Error'
          end
        end
      rescue RuntimeError => e
        if e.message == 'Auth Error' and !retried
          Rails.logger.error('Auth error, trying to refresh the token')
          retried = true
          refresh()
          retry
        else
          Rails.logger.error("Something else happened #{e.message}")
        end
      end
      Rails.logger.info(resp = JSON.parse(res.body))
      next_page_token = resp['nextPageToken']
      parse_search_list(resp) 
    end
    Rails.logger.info("Successfully processed #{@sum_count} videos")
  end

  def parse_search_list(resp)
    if resp['error']
      Rails.logger.error('Something happened: ' + resp['error']['code'].to_s)
      return
    end
    resp['items'].each {|item|
      if item['id'] and item['id']['videoId'] 
        Rails.logger.info('Processing video ' + item['id']['videoId'])
      else
        Rails.logger.info('Processing video ' + item['kind'])
      end
      next unless item['kind'] == 'youtube#searchResult'
      next unless item['id'] and item['id']['kind'] == 'youtube#video'
      next unless (snippet = item['snippet'])
      next unless (video_id = item['id']['videoId'])
      store_song_info(video_id, snippet) { @sum_count += 1 }
    }
  end

  def store_song_info(video_id, snippet)
    begin
      song = Song.find_or_create_by(
        video_id: video_id, published_at: snippet['publishedAt'],
        channel_id: snippet['channelId'],
        title: snippet['title'],
        description: snippet['description'],
        image_url: snippet['thumbnails']['default']['url'],
        channel_title: snippet['channelTitle'])
      if (song.id > (@max_song_id + @sum_count))
        Rails.logger.info('Successfully stored video for ' + video_id)
        yield
      end
    rescue ActiveRecord::RecordNotUnique
      Rails.logger.error("Index violation by #{video_id} ignored")
    end
  end
end
