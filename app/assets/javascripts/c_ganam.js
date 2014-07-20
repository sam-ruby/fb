(function() {
  var c_ganam = angular.module('cGanam',
    ['ngResource', 'ui.bootstrap']);

  c_ganam.controller('SongListController', ['$log', '$resource', function($log, $resource) {
    var that = this;
    that.current_page = 1;
    that.total_songs = null;
    that.per_page = 25;
    that.max_size = 10;
    
    var params = function() {
      return {
        total_songs: that.total_songs,
        page: that.current_page,
        per_page: that.per_page
      };
    };

    var SongList = $resource('/songs.json');
    
    var handle_song_list = function(songList) {
      if (that.total_songs === null) {
        that.total_songs = songList.total_songs ;
      }
      that.songs = songList.songs;
    };
    SongList.get(params(), handle_song_list);
    that.page_changed = function() {
      SongList.get(params(), handle_song_list);
    };
  }]);

  c_ganam.directive('song', function() {
    return {
      restrict: 'E',
      templateUrl: '/templates/song_list/song.html'
    };
  });
})();

