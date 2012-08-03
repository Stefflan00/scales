module Scales
  module Server
    module Proxy
      
      class Backend
        @ports = []
        attr_reader   :url, :host, :port
        attr_accessor :load
        alias         :to_s :url

        def initialize(options={})
          raise ArgumentError, "Please provide a :url and :load" unless options[:url]
          @url   = options[:url]
          @load  = options[:load] || 0
          parsed = URI.parse(@url)
          @host, @port = parsed.host, parsed.port
        end
        
        def self.add(ports)
          ports.each{ |port| @ports << { :url => "http://0.0.0.0:#{port}" } }
        end
        
        def self.ports
          @ports.map{ |port| port[:url].split(":").last }
        end

        def self.select(strategy = :balanced)
          @strategy = strategy.to_sym
          case @strategy
            when :balanced
              backend = list.sort_by { |b| b.load }.first
            when :roundrobin
              @pool   = list.clone if @pool.nil? || @pool.empty?
              backend = @pool.shift
            when :random
              backend = list[ rand(list.size-1) ]
            else
              raise ArgumentError, "Unknown strategy: #{@strategy}"
          end

          Callbacks.on_select.call(backend)
          yield backend if block_given?
          backend
        end

        def self.list
          @list ||= @ports.map { |backend| new backend }
        end

        def self.strategy
          @strategy
        end

        def increment_counter
          self.load += 1
        end

        def decrement_counter
          self.load -= 1
        end

      end
      
    end
  end
end