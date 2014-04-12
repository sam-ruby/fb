class Fb.Models.Song extends Backbone.Model

class Fb.Collections.Song extends Backbone.Collection
  model: Fb.Model.SongList
  url: '/song/get_list'
  mode: 'server'
  state:
    pageSize: 50
