class Fb.Views.SongList extends Backbone.View
  initialize: (options) =>
    super(options)
    view = this
    @listenTo(CGanam.Events, 'group-not-found', @render_group_access_error)
    @listenTo(CGanam.Events, 'load-videos', @load_videos)
    @listenTo(CGanam.Events, 'feed-pagination-marker',
      (@group_id, @tokens) ->)
    @listenTo(CGanam.Events, 'get-song-group', ->
      @marker.addClass('more-songs')
    )
    @listenTo(CGanam.Events, 'group-not-found', ->
      @marker.removeClass('more-songs')
    )
    @listenTo(CGanam.Events, 'videos:get-latest', @unrender)
      
    @request_mode = false
    marker = @$el.find('#eof')

    get_next_set = ()->
      marker.addClass('more-songs')
      CGanam.Events.trigger(
        'get-next-set-feed', view.group_id, view.tokens)

    handler = () ->
      rect = marker[0].getBoundingClientRect()
      if (rect.top > 0 and rect.left > 0 and (rect.bottom-10) <= $(window).height() and rect.right <= $(window).width() and !view.request_mode)
        view.request_mode = true
        get_next_set()

    $(document).on('DOMContentLoaded load resize scroll', handler)
    @marker = marker

  load_videos: (videos) =>
    @marker.removeClass('more-songs')
    @render(videos)

  events: 
    'click li.song a': 'handle_image_click'

  handle_image_click: (e) ->
    e.preventDefault()
    $(e.target).parents('li.song').find('input.videos-selected').click()

  unrender: =>
    @$el.children().not('#eof').remove()

  render: (videos) =>
    if (list = @$el.find('ol.song-list')) and list.length == 0
      list = $('<ol class="song-list"></ol>')

    template = JST['backbone/templates/song_list']
    list.append( template(
      first_time: true,
      songs: videos))
    @$el.prepend(list)
    @request_mode = false
    @marker.empty()

  render_group_access_error: (group_name)->
    group_access_error_template = JST['backbone/templates/group_error']
    @$el.prepend( group_access_error_template(group_name:group_name) )
