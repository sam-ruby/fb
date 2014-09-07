class Fb.Views.SongList extends Backbone.View
  initialize: (options) =>
    super(options)
    view = this
    @listenTo(CGanam.Events, 'load-videos', @load_videos)
    @listenTo(CGanam.Events, 'feed-pagination-marker',
      (@group_id, @tokens) ->)
      
    @request_mode = false
    marker = @$el.find('#eof')

    get_next_set = ()->
      CGanam.Events.trigger(
        'get-next-set-feed', view.group_id, view.tokens)

    handler = do (marker) =>
      =>
        rect = marker[0].getBoundingClientRect()
        if (rect.top > 0 and rect.left > 0 and rect.bottom <= $(window).height() and rect.right <= $(window).width() and !@request_mode)
          @request_mode = true
          marker.addClass('more-songs')
          get_next_set()

    $(document).on('DOMContentLoaded load resize scroll', handler)
    @marker = marker

  load_videos: (videos) =>
    @render(videos)

  events: 
    'click li.song a': 'handle_image_click'

  handle_image_click: (e) ->
    e.preventDefault()
    $(e.target).parents('li.song').find('input.videos-selected').click()

  render: (videos) =>
    @marker.removeClass('more-songs')
    if (list = @$el.find('ol.song-list')) and list.length == 0
      list = $('<ol class="song-list"></ol>')

    template = JST['backbone/templates/song_list']
    list.append( template(
      first_time: true,
      songs: videos))
    @$el.prepend(list)
    @request_mode = false
    @marker.empty()
