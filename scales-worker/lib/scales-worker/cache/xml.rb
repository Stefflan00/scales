module Scales
  module Worker
    module Cache
      module XML
        include Helper::ContentTypes
        
        class << self
          
          def append(params = {})
            xml = params[:xml]
            path = params[:to] || params[:at]
            change_content_at(path, params[:select]) do |selection|
              selection.each{ |element| element.children.last.after xml }
            end
          end
          
          def prepend(params = {})
            xml = params[:xml]
            path = params[:to] || params[:at]
            change_content_at(path, params[:select]) do |selection|
              selection.each{ |element| element.children.first.before xml }
            end
          end
          
          def set(params = {})
            xml = params[:xml]
            path = params[:to] || params[:at]
            change_content_at(path, params[:select]) do |selection|
              selection.each{ |element| element.inner_html = xml }
            end
          end
          
          def replace(params = {})
            xml = params[:xml]
            path = params[:to] || params[:at]
            change_content_at(path, params[:select]) do |selection|
              selection.each{ |element| element.replace xml }
            end
          end
          
          def remove(params = {})
            path = params[:to] || params[:at]
            change_content_at(path, params[:select]) do |selection|
              selection.each{ |element| element.remove }
            end
          end
          
          
          private
          
          def change_content_at path, selector
            raise 'No path defined like this :to => "/tracks.xml"'      if path.nil?
            raise 'No selector defined like this :select => "/tracks"'  if selector.nil?
            
            xml = Storage::Sync.get(path)
            xml = Nokogiri::XML.parse(xml)
            
            yield xml.xpath(selector)
            
            Storage::Sync.set(path, xml.inner_html)
            xml.inner_html
          end
                
        end
      end
    end
  end
end