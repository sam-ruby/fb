class Fb.Models.PlayList extends Backbone.Model

class Fb.Collections.PlayList extends Backbone.PageableCollection
  model: Fb.Models.PlayList
  url: '/play_lists'
  mode: 'client'
  state:
    pageSize: 5
