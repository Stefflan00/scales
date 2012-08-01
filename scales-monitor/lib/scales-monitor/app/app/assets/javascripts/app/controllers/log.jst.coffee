class App.Log extends Spine.Controller
  
  elements:
    '#events'  : 'eventsDiv'
    
  constructor: ->
    super
    @render()
    @bindEvents()
    setInterval => 
      @eventsDiv.animate({ scrollTop: @eventsDiv[0].scrollHeight }, 500)
    , 1000
  
  activate: ->
    @el.addClass("active")
    $("li#nav_log").addClass('active')
    @

  deactivate: ->
    @el.removeClass("active")
    $("li#nav_log").removeClass('active')
    @
  
  bindEvents: ->
    
    Spine.bind 'server_started',    (event) => @add(event)
    Spine.bind 'server_stopped',    (event) => @add(event)
  
    Spine.bind 'worker_started',    (event) => @add(event)
    Spine.bind 'worker_stopped',    (event) => @add(event)
    
    Spine.bind 'cache_started',     (event) => @add(event)
    Spine.bind 'cache_stopped',     (event) => @add(event)
    
    Spine.bind 'server_put_request_in_queue',     (event) => @add(event)
    Spine.bind 'server_took_response_from_queue', (event) => @add(event)
    Spine.bind 'worker_took_request_from_queue',  (event) => @add(event)
    Spine.bind 'worker_put_response_in_queue',    (event) => @add(event)
    
    Spine.bind 'push_resource',     (event) => @add(event)
    Spine.bind 'destroy_resource',  (event) => @add(event)
    
    Spine.bind 'push_partial',      (event) => @add(event)
    Spine.bind 'destroy_partial',   (event) => @add(event)
   
  
  render: (event) ->
    @html JST['app/views/log'](@)
  
  add: (event) ->
    out = "<br/><span class='date'>#{new Date().getTime()}</span> <span class='event'>#{event.type}</span>"
    for item, data of event
      if item == "key" or item == "safe" or item == "escape" or item == "server" or item == "color" or item == "type"
        # no need for them
      else
        out += "<br/>&nbsp;&nbsp;&nbsp; -> #{item} = #{data}"
      
    @eventsDiv.append out