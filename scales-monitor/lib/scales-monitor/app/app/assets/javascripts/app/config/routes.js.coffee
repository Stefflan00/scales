class App.Routes extends Spine.Stack
  controllers:
    machines    : App.Machines
    queues      : App.Queues
    
  routes:
    '/machines' : 'machines'
    '/queues'   : 'queues'
    
  default:      'machines'
  className:    'stack base'