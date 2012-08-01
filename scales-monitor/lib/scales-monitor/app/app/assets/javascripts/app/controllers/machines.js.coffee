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
  
  activate: ->
    @el.addClass("active")
    $("li#nav_machines").addClass('active')
    @

  deactivate: ->
    @el.removeClass("active")
    $("li#nav_machines").removeClass('active')
    @
  
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
    
    Spine.bind 'cache_started', (cache) =>
      @caches[cache.id] = cache
      @renderMachines(@caches, @cachesDiv)

    Spine.bind 'cache_stopped', (cache) =>
      delete @caches[cache.id]
      @renderMachines(@caches, @cachesDiv)
  
  render: ->
    @html JST['app/views/machines'](@)
  
  renderMachines: (machines, div) ->
    machineAmount = 0
    machineAmount += 1 for id, machine of machines
    out = JST['app/views/_top']({amount: machineAmount})
    
    out += JST['app/views/_machine'](machine) for id, machine of machines
    div.html out
    $("time.timeago").timeago()