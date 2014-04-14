class Fb.Views.PlayList extends Backbone.View
  initialize: (options) =>
    super(options)
    @router = Fb.Routers.Main
    @collection = new Fb.Collections.PlayList()
    @listenTo(@router, 'route:home', (params) ->
      @collection.fetch(reset: true)
    )
    @listenTo(@collection, 'reset', @render)

  render: =>
    if (list = @$el.find('ol.play-lists')) and list.length == 0
      list = $('<ol class="play-lists"></ol>')

    template = JST['backbone/templates/play_list']
    list.append( template(play_lists: @collection.toJSON()) )
    @$el.prepend(list)
