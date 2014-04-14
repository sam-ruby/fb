class Fb.Views.SongList extends Backbone.View
  initialize: (options) =>
    super(options)
    @router = Fb.Routers.Main
    collection = new Fb.Collections.Song()
    @listenTo(@router, 'route:home', (params) ->
      collection.fetch(reset: true)
    )
    @listenTo(collection, 'reset', @render)
    @request_mode = false
    marker = @$el.find('#eof')
    get_next_set = do (collection, marker) ->
      ->
        collection.getNextPage(reset: true)
        marker.addClass('more-songs')

    handler = do (marker) =>
      =>
        rect = marker[0].getBoundingClientRect()
        if (rect.top > 0 and rect.left > 0 and rect.bottom <= $(window).height() and rect.right <= $(window).width() and !@request_mode)
          @request_mode = true
          marker.addClass('more-songs')
          setTimeout(get_next_set, 2000)

    $(document).on('DOMContentLoaded load resize scroll', handler)
    @marker = marker
    @collection = collection

  render: =>
    @marker.removeClass('more-songs')
    if (list = @$el.find('ol.song-list')) and list.length == 0
      list = $('<ol class="song-list"></ol>')

    template = JST['backbone/templates/song_list']
    list.append( template(
      first_time: true,
      songs: @collection.toJSON()) )
    @$el.prepend(list)
    @request_mode = false
    @marker.empty()
