#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.Fb =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}

class MainRouter extends Backbone.Router
  initialize: (options) ->
    super(options)

  routes:
    "playlist(/*args)" : "playlist"
    "(main)(/*args)" : "home"
  
  _extractParameters: (route, fragment) =>
    results = {}
    return results unless fragment?
    parts = (part for part in fragment.split('/') when part != '')
    for k, index in part
      continue if index%2 != 0
      results[k] = parts[index+1]
    results

  home: (@params)=>

Fb.Routers.Main = new MainRouter()
