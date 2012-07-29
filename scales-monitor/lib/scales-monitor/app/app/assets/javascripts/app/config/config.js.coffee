# Namespace
window.App = ->

# Remote endpoint
Spine.Model.host = "http://localhost:3000"

class App.Config
  
  # Access this values from all over the app through App.Config.SOME_VALUE
  # @SOME_VALUE : 12