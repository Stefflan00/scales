class App.Queues extends Spine.Controller
  
  elements:
    '#requests'   : 'requestsDiv'
    '#processing' : 'processingDiv'
    '#responses'  : 'responsesDiv'
    
  constructor: ->
    super
    [@requests, @processing, @responses] = [{}, {}, {}]
    @render()
    @bindEvents()
  
  activate: ->
    @el.addClass("active")
    $("li#nav_queues").addClass('active')
    @
  
  deactivate: ->
    @el.removeClass("active")
    $("li#nav_queues").removeClass('active')
    @
  
  bindEvents: ->
    
    Spine.bind 'server_put_request_in_queue', (request) =>
      @requests[request.id] = request
      @renderQueueItems(@requests, @requestsDiv)
    
    Spine.bind 'worker_took_request_from_queue', (request) =>
      delete @requests[request.id]
      @processing[request.id] = request
      @renderQueueItems(@requests, @requestsDiv)
      @renderQueueItems(@processing, @processingDiv)
    
    Spine.bind 'worker_put_response_in_queue', (response) =>
      delete @processing[response.id]
      @responses[response.id] = response
      @renderQueueItems(@processing, @processingDiv)
      @renderQueueItems(@responses, @responsesDiv)

    Spine.bind 'server_took_response_from_queue', (response) =>
      delete @responses[response.id]
      @renderQueueItems(@responses, @responsesDiv)
  
  render: ->
    @html JST['app/views/queues'](@)
  
  renderQueueItems: (items, div) ->
    itemAmount = 0
    itemAmount += 1 for id, item of items
    div.html JST['app/views/_queue_top']({amount: itemAmount})
    
    out = ""
    out += JST['app/views/_queue_item'](item) for id, item of items
    div.append out