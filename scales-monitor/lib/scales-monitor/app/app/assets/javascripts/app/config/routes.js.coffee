class App.Routes extends Spine.Stack
  controllers:
    machines : App.Machines
    
  routes:
    '/' : 'machines'
    
  default: 'machines'
  className: 'stack base'