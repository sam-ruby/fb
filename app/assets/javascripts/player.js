$(function(){
  var player;
  var load_player = function(){
    player = new YT.Player('player', {
      height: '390',
      width: '640', 
      events: {
        'onReady': on_player_ready,
        'onStateChange': on_state_change
      }
    });
    console.log('Player inited');
  }

  var on_player_ready = function() {
    console.log('Player is ready');
  }

  var on_state_change = function(e) {
    if (e.data && e.data == 5) {
      $('#player').show();
      player.playVideo();
    }
  };

  var queue_videos = function() {
    var video_ids = [];
    $('input.videos-selected:checked').each(function(index) {
      video_ids.push($(this).val());
    });
    if (video_ids.length) {
      console.log('queuing the videos', video_ids);
      player.cuePlaylist({playlist: video_ids});
    }
  };

  var show_play_button = function() {
    $('div.page-title').show();
  };
  
  CGanam.Player = _.extend({}, Backbone.Events);
  CGanam.Player.listenTo(
      CGanam.Events, 'show-play-button', show_play_button);
  CGanam.Player.listenTo(
      CGanam.Events, 'play-videos', queue_videos);
  CGanam.Player.listenTo(
      CGanam.Events, 'youtube-iframe-api-ready', load_player);
});
