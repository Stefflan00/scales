class App.Index extends Spine.Controller
  constructor: ->
    super
    
    @append new App.Routes
    
    App.Socket.setup()
    Spine.Route.setup(history: true)