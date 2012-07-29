class App.Socket
  
  @setup: ->
    console.log "Connecting to #{App.Config.webSocket}"
    @socket = new WebSocket(App.Config.webSocket)
    
    @socket.onopen = => 
      console.log("Connected")
      
    @socket.onerror = (error) => 
      console.log "Error: #{error}"
      
    @socket.onmessage = (message) =>
      data = JSON.parse(message.data)
      type = data.type
      console.log "Received: #{type} with data:"
      console.log data
      Spine.trigger type, data