module Scales
  module Helper
    module ContentTypes
      
      TYPES = {
        :html  => 'text/html',
        :htm   => 'text/html',
        :txt   => 'text/plain',
        :css   => 'text/css',
        :yaml  => 'text/yaml',
        :js    => 'application/javascript',
        :json  => 'application/json',
        :rss   => 'application/rss+xml',
        :xml   => 'application/xml',
        :pdf   => 'application/pdf'
      }
      
      class ::Symbol
        def to_content_type
          Scales::Helper::ContentTypes::TYPES[self]
        end
      end
      
    end
  end
end