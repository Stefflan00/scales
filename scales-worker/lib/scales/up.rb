module Scales
  class Up < ::Rake::TaskLib
    include ::Rake::DSL if defined?(::Rake::DSL)
    
    attr_reader :name
    attr_reader :app
    attr_accessor :paths

    def push format, options
      paths << { :format => format, :push => true }.merge(options)
    end
    
    def update format, options
      paths << { :format => format }.merge(options)
    end

    def initialize(*args)
      @name   = args.shift || :up
      @paths  = []
      @app    = nil
      @pusher = Scales::Worker::Pusher.new
      
      desc "Scale up task" unless ::Rake.application.last_comment
      task name do
        RakeFileUtils.send(:verbose, verbose) do
          @app = Up.application.initialize_environment!

          yield self if block_given?
          
          @pusher.push!(@paths)
        end
      end
    end
    
    class << self
      @@application = Worker::Application::Rails
      
      def application
        @@application
      end
      
      def application=(application)
        @@application = application
      end
    end
  end
end