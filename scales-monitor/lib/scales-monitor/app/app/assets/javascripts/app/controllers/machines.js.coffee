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
      @renderMachines(@servers, @serversDiv)
    
    Spine.bind 'server_stopped', (server) =>
      delete @servers[server.id]
      @renderMachines(@servers, @serversDiv)
    
    Spine.bind 'worker_started', (worker) =>
      @workers[worker.id] = worker
      @renderMachines(@workers, @workersDiv)

    Spine.bind 'worker_stopped', (worker) =>
      delete @workers[worker.id]
      @renderMachines(@workers, @workersDiv)
  
  render: ->
    @html JST['app/views/machines'](@)
  
  renderMachines: (machines, div) ->
    out = ""
    out += JST['app/views/_machine'](machine) for id, machine of machines
    div.html out
    $("time.timeago").timeago()