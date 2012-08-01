class App.Socket
  
  @setup: ->
    @socket = new WebSocket(App.Config.webSocket)
          
    @socket.onmessage = (message) =>
      data = JSON.parse(message.data)
      type = data.type
      Spine.trigger type, data