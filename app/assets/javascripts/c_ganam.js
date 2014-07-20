(function() {
  var c_ganam = angular.module('cGanam', ['ngResource']);

  c_ganam.controller('SongListController', ['$log', '$resource', function($log, $resource) {
    var SongList = $resource('/songs.json');
    var that = this;
    SongList.query(function(songs) {
      that.songs = songs;
    });
  }]);

  c_ganam.directive('song', function() {
    return {
      restrict: 'E',
      templateUrl: '/templates/song_list/song.html'
    };
  });
})();

