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
  routes:
    '(list)' : 'main'
  
  _extractParameters: (route, fragment) =>
    parts = (part for part in fragment.split('/') when part != '')
    results = {}
    for k, index in part
      continue if index%2 != 0
      results[k] = parts[i+1]
    results

  main: (@params) =>

Fb.Routers.Main = new MainRouter()
Backbone.history.start()
