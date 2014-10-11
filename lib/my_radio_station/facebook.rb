module MyRadioStation
  class Facebook
    attr_accessor :access_token, :graph

    def start_job
      @logger = Rails.logger
      @logger.info 'Starting job now.'
      self.start_job
      record = AccessToken.first
      return if record.nil?
      self.graph = Koala::Facebook::API.new(record.token)
      group_id = self.get_song_group
      @logger.info('Recording group id ' + group_id)
      while (feeds = get_group_feeds(group_id)) do
        @logger.info('Going for the next page of group feeds')
      end
    end
    handle_asynchronously :start_job,
      :run_at => Proc.new { 10.minutes.from_now }

    def get_song_group
      groups = graph.get_connections("me", "groups")
      groups.select {|g| 
        g['name'] == 'Malayalam Songs' }.first['id']
    end

    def get_group_feeds(group_id)
      tries = 3
      if @next_page_params.nil?
        begin
          feeds = graph.get_connections(group_id, 'feed')
        rescue Koala::Facebook::ServerError
          sleep 5
          tries -= 1
          @logger.info('Got exception, retrying')
          retry if tries > 0
        end
        @logger.info('Got feeds for the first page')
        return false if feeds.nil?
        @next_page_params = feeds.next_page_params
      else
        begin
         feeds = graph.get_page(@next_page_params)
        rescue Koala::Facebook::ServerError
          sleep 5
          tries -= 1
          @logger.info('Got exception, retrying')
          retry if tries > 0
        end
        @logger.info('Got feeds for the next page')
        return false if feeds.nil?
        @next_page_params = feeds.next_page_params
      end
      result = false
      feeds.each {|feed| 
        fb_id = feed['id']
        @logger.info(feed)
        @logger.info('Checking the post ID ' + fb_id)
        if Song.where(fb_post_id: fb_id).size > 0
          result = false
          @logger.info('In DB; so stopping')
          break
        end
        video_id = self.parse_video_link(feed)
        @logger.info('Got the video id ' + video_id.to_s)
        if video_id
          begin
            Song.create(fb_post_id: fb_id, video_id: video_id,
                        fb_created_time: feed['created_time'],
                        fb_updated_time: feed['updated_time'])
          rescue ActiveRecord::RecordNotUnique
            @logger.info('That record was there. No problem')
          end
          result = true
        end
      }
      false or result
    end

    def parse_video_link(feed)
      if (feed and (feed['type'] == 'status' or feed['type'] == 'photo') and 
        feed['message'])
        @logger.info('Status is ' + feed['message'])
        match = feed['message'].match(/http.+(youtube|you).+(com)?[^\s]+/)
        return get_youtube_id(match[0]) if match
      elsif (feed and feed['type'] == 'video' and feed['source'])
        return get_youtube_id(feed['source']) if feed['source']
      end
      false
    end

    def get_youtube_id(link)
      if link
        if link.match('v=')
          video_id = link.split("v=")[1]
          video_id = video_id[0, 11]
        elsif link.match('v/')
          video_id = link.split("v/")[1]
          video_id = video_id[0, 11]
        elsif link.match('youtu.be/')
          video_id = link.split("youtu.be/")[1]
          video_id = video_id[0, 11]
        end
      end
    end
  end
end

