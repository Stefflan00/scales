# Namespace
window.App = ->

# Remote endpoint
Spine.Model.host = "http://localhost:3000"

class App.Config
  @webSocket : "ws://localhost:9000/socket"