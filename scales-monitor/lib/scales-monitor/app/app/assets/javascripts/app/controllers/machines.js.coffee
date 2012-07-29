class App.Machines extends Spine.Controller
  
  elements:
    '#servers'  : 'serversDiv'
    '#caches'   : 'cachesDiv'
    '#workers'  : 'workersDiv'
    
  constructor: ->
    super
    [@servers, @caches, @workers] = [[{name:"Test"}], [], []]
    @render()
    @renderServers()
  
  render: ->
    @html JST['app/views/machines'](@)
  
  renderServers: ->
    out = ""
    out += JST['app/views/_machine'](server) for server in @servers
    @serversDiv.html out
  
  renderCaches: ->
    out = ""
    out += JST['app/views/_machine'](cache) for cache in @caches
    @cachesDiv.html out
  
  renderWorkers: ->
    out = ""
    out += JST['app/views/_machine'](worker) for worker in @workers
    @workersDiv.html out