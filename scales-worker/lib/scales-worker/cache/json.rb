module Scales
  module Worker
    module Cache
      module JSON
        include Helper::ContentTypes
        
        class << self
          
          def append(params = {})
            json = params[:json]
            path = params[:to] || params[:at]
            change_content_at(path, params[:select]) do |selection, selector|
              selection.gsub(selector){ |selection| selection << parse(json) }
            end
          end
          
          def prepend(params = {})
            json = params[:json]
            path = params[:to] || params[:at]
            change_content_at(path, params[:select]) do |selection, selector|
              selection.gsub(selector){ |selection| (selection.reverse << parse(json)).reverse }
            end
          end
          
          def set(params = {})
            json = params[:json]
            path = params[:to] || params[:at]
            change_content_at(path, params[:select]) do |selection, selector|
              selection.gsub(selector){ |selection| selection = parse(json) }
            end
          end
          
          def replace(params = {})
            set(params)
          end
          
          def remove(params = {})
            path = params[:to] || params[:at]
            change_content_at(path, params[:select]) do |selection, selector|
              selection.delete(selector)
            end
          end
          
          
          private
          
          def parse(json)
            ::JSON.parse(json)
          end
          
          def change_content_at path, selector
            raise 'No path defined like this :to => "/tracks.json"'          if path.nil?
            raise 'No selector defined like this :select => "#tracks"'  if selector.nil?
            
            json = Storage::Sync.get(path)
            json = JsonPath.for(json)
            
            json = yield json, selector
            
            Storage::Sync.set(path, json.to_hash.to_json)
            json
          end
                
        end
      end
    end
  end
end