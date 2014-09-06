(function(){
  var get_video_data = function(ids) {
    console.log('IDS are ', ids.join(','));
    var request = gapi.client.youtube.videos.list(
      {id: ids.join(','), part: 'id,snippet,contentDetails'});
    request.execute(function(response) {
      console.log(response);
    });
  };

  CGanam.YouTube = _.extend({get_video_data: get_video_data},
    Backbone.Events);
  CGanam.YouTube.listenTo(CGanam.Events, 'load_videos', get_video_data);
})();
