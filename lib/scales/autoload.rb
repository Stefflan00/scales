autoload :Redis,        "scales/initializers/redis"
autoload :EventMachine, "scales/initializers/em"
autoload :Goliath,      "scales/initializers/goliath"

module EventMachine
  autoload :Synchrony,  "scales/initializers/em"
  autoload :Hiredis,    "scales/initializers/em"
end

module EM
  autoload :Synchrony,  "scales/initializers/em"
  autoload :Hiredis,    "scales/initializers/em"
end