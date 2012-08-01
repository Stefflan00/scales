class App.Routes extends Spine.Stack
  controllers:
    machines      : App.Machines
    queues        : App.Queues
    resources     : App.Resources
    
  routes:
    '/machines'   : 'machines'
    '/queues'     : 'queues'
    '/resources'  : 'resources'
    
  default:      'machines'
  className:    'stack base'