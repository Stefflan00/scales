module Scales
  module Worker
    module Job
      class << self
    
        def to_env(job)
          env = JSON.parse(job)
          env['rack.input'] = StringIO.new(env['rack.input'])
          env
        end
    
      end
    end
  end
end