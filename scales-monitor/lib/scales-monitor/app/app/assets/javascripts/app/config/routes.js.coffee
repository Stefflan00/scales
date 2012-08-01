class App.Routes extends Spine.Stack
  controllers:
    machines      : App.Machines
    queues        : App.Queues
    resources     : App.Resources
    log           : App.Log
    
  routes:
    '/machines'   : 'machines'
    '/queues'     : 'queues'
    '/resources'  : 'resources'
    '/log'        : 'log'
    
  default:      'machines'
  className:    'stack base'