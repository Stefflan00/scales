class App.Machines extends Spine.Controller
  
  elements:
    '#servers'  : 'serversDiv'
    '#caches'   : 'cachesDiv'
    '#workers'  : 'workersDiv'
    
  constructor: ->
    super
    [@servers, @caches, @workers] = [{}, {}, {}]
    @render()
    @bindEvents()
  
  bindEvents: ->
    Spine.bind 'server_started', (server) =>
      @servers[server.id] = server
      @renderServers()
    
    Spine.bind 'server_stopped', (server) =>
      delete @servers[server.id]
      @renderServers()
  
  render: ->
    $("time.timeago").timeago()
    @html JST['app/views/machines'](@)
    
  
  renderServers: ->
    out = ""
    out += JST['app/views/_machine'](server) for id, server of @servers
    @serversDiv.html out
  
  renderCaches: ->
    out = ""
    out += JST['app/views/_machine'](cache) for cache in @caches
    @cachesDiv.html out
  
  renderWorkers: ->
    out = ""
    out += JST['app/views/_machine'](worker) for worker in @workers
    @workersDiv.html out