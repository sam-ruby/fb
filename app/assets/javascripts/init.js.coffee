$ ->
  songList = new Fb.Views.SongList(el: '#song-list')
  playList = new Fb.Views.PlayList(el: '#play-lists')
  Backbone.history.start()
