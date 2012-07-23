module Scales
  class Up < ::Rake::TaskLib
    include ::Rake::DSL if defined?(::Rake::DSL)
    include Helper::ContentTypes
    
    attr_reader :name
    attr_reader :app
    attr_accessor :paths

    def push format, options
      paths << { :format => format, :push => true }.merge(options)
    end
    
    def update *new_paths, params
      raise "Please define a format like this :format => :html" unless params.is_a?(Hash)
      format = params.delete(:format)
      raise "Unknown format :#{format}"                         if format.to_content_type.nil?
      new_paths.each{ |path| paths << { :format => format, :to => path }}
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