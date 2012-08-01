class App.Resources extends Spine.Controller
  
  elements:
    '#resources'      : 'resourcesDiv'
    '#partials'       : 'partialsDiv'
    '#content_types'  : 'contentTypesDiv'
    
  constructor: ->
    super
    [@resources, @partials, @servers] = [{}, {}, {}]
    @colors = {}
    @bindColors()
    @render()
    @bindEvents()
  
  activate: ->
    @el.addClass("active")
    $("li#nav_resources").addClass('active')
    @

  deactivate: ->
    @el.removeClass("active")
    $("li#nav_resources").removeClass('active')
    @
  
  bindColors: ->
    @colors = 
      'HTML'  : '#EDFFA3'
      'CSS'   : '#A3E2FF'
      'JS'    : '#FFDAA3'
      'JSON'  : '#FFA3A3'
      'XML'   : '#A3FFE5'
      'PDF'   : '#FFA3E2'
      'TXT'   : '#C0A3FF'
      'PNG'   : '#FFC4EE'
      'JPG'   : '#C4FFF3'
      'ZIP'   : '#FDFFC4'
  
  bindEvents: ->
    
    Spine.bind 'push_resource', (resource) =>
      @resources[resource.path] = resource
      @renderResources(@resources, @resourcesDiv)
    
    Spine.bind 'destroy_resource', (resource) =>
      delete @resources[resource.path]
      @renderResources(@resources, @resourcesDiv)
    
    Spine.bind 'push_partial', (partial) =>
      @partials[partial.path] = partial
      @renderResources(@partials, @partialsDiv)

    Spine.bind 'destroy_partial', (partial) =>
      delete @partials[partial.path]
      @renderResources(@partials, @partialsDiv)
    
    Spine.bind 'server_started', (server) =>
      @servers[server.id] = server
      @renderResources(@resources, @resourcesDiv)

    Spine.bind 'server_stopped', (server) =>
      delete @servers[server.id]
      @renderResources(@resources, @resourcesDiv)
  
  render: ->
    @html JST['app/views/resources'](@)
  
  renderResources: (resources, div) ->
    resourceAmount = 0
    resourceAmount += 1 for id, resource of resources
    out = JST['app/views/_top']({amount: resourceAmount})
    
    resourcesArray = []
    resourcesArray.push(resource) for id, resource of resources
    resourcesArray.sort (a, b) ->
      return -1 if a.format < b.format
      return 1  if a.format > b.format
      0
    
    @i = 0
    for resource in resourcesArray
      out += "<div class='row'>" if @i == 0
      resource.color = @colors[resource.format]
      resource.server = server for id, server of @servers
      out += JST['app/views/_resource'](resource)
      @i += 1
      if @i == 4
        out += "</div>"
        @i = 0
      
    div.html out
    div.tooltip({ selector: "a" })
    @renderContentTypes()
  
  processContentTypes: ->
    formats = {}
    total = 0
    for id, resource of @resources
      total += 1
      if not formats[resource.format] then formats[resource.format] = { amount: 1 } else formats[resource.format].amount += 1
    
    for id, partial of @partials
      total += 1
      if not formats[partial.format] then formats[partial.format] = { amount: 1 } else formats[partial.format].amount += 1
    
    formatsArray = []
    for format, model of formats
      model.format = format
      model.progress = (model.amount / total) * 100
      model.color = @colors[model.format]
      formatsArray.push(model)
    
    formatsArray.sort (a, b) ->
      return 1 if a.progress < b.progress
      return -1  if a.progress > b.progress
      0
    
    [formatsArray, total]
  
  renderContentTypes: ->
    [formats, total] = @processContentTypes()
    
    out = JST['app/views/_top']({amount: total})
    out += JST['app/views/_format_bar'](format) for format in formats
    @contentTypesDiv.html out
    
    
    