(function(){
  var get_video_data = function(ids) {
    var request = gapi.client.youtube.videos.list(
      {id: ids.join(','), part: 'id,snippet,contentDetails'});
    request.execute(function(response) {
      if (response.kind == "youtube#videoListResponse") {
        console.log('Loading videos ', response.items);
        CGanam.Events.trigger('load-videos', response.items);
        CGanam.Events.trigger('show-play-button');
      } else {
        console.log("Not the expected response", response);
      }
    });
  };

  CGanam.YouTube = _.extend({get_video_data: get_video_data},
    Backbone.Events);
  CGanam.YouTube.listenTo(CGanam.Events, 'get-video-details', get_video_data);
})();
