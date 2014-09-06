class Fb.Views.SongList extends Backbone.View
  initialize: (options) =>
    super(options)
    collection = new Fb.Collections.Song()
    @listenTo(collection, 'reset', @render)
    @listenTo(CGanam.Events, 'load-songs', @load_songs)
    
    @request_mode = false
    marker = @$el.find('#eof')

    get_next_set = (collection, marker) ->
      CGanam.Events.trigger('get-next-set-songs')

    handler = do (marker) =>
      =>
        rect = marker[0].getBoundingClientRect()
        if (rect.top > 0 and rect.left > 0 and rect.bottom <= $(window).height() and rect.right <= $(window).width() and !@request_mode)
          @request_mode = true
          marker.addClass('more-songs')
          get_next_set()

    $(document).on('DOMContentLoaded load resize scroll', handler)
    @marker = marker
    @collection = collection

  load_songs: (data) =>
    console.log 'Here is the data ', data
    for link in data
      @process_data(link)

  process_data: (data) =>
    console.log data

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
