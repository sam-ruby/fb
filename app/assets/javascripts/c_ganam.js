var c_ganam = angular.module('cGanam', []);

c_ganam.controller('SongListController', ['$log', function($log) {
}]);

c_ganam.directive('song', function() {
  return {
    restrict: 'E',
    templateUrl: '/templates/song_list/song.html'
  };
});

