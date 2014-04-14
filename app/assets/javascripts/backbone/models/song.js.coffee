class Fb.Models.Song extends Backbone.Model

class Fb.Collections.Song extends Backbone.PageableCollection
  model: Fb.Models.Song
  url: '/songs'
  mode: 'server'
  state:
    pageSize: 50
