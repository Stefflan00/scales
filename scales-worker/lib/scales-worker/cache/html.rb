module Scales
  module Worker
    module Cache
      module HTML
        include Helper::ContentTypes
        
        class << self
          
          def append(params = {})
            html = params[:html]
            path = params[:to] || params[:at]
            change_content_at(path, params[:select]) do |selection|
              selection.each{ |element| element.children.last.after html }
            end
          end
          
          def prepend(params = {})
            html = params[:html]
            path = params[:to] || params[:at]
            change_content_at(path, params[:select]) do |selection|
              selection.each{ |element| element.children.first.before html }
            end
          end
          
          def set(params = {})
            html = params[:html]
            path = params[:to] || params[:at]
            change_content_at(path, params[:select]) do |selection|
              selection.each{ |element| element.inner_html = html }
            end
          end
          
          def replace(params = {})
            html = params[:html]
            path = params[:to] || params[:at]
            change_content_at(path, params[:select]) do |selection|
              selection.each{ |element| element.replace html }
            end
          end
          
          def remove(params = {})
            path = params[:to] || params[:at]
            change_content_at(path, params[:select]) do |selection|
              selection.each{ |element| element.remove }
            end
          end
          
          
          private
          
          def is_html_page?(page)
            page.match /<html>/
          end
          
          def change_content_at path, selector
            raise 'No path defined like this :to => "/tracks"'          if path.nil?
            raise 'No selector defined like this :select => "#tracks"'  if selector.nil?

            html = Storage::Sync.get_content(path)
            html = is_html_page?(html) ? Nokogiri::HTML.parse(html) : Nokogiri::HTML.fragment(html)
            
            yield html.css(selector)
            
            Storage::Sync.set_content(path, html.inner_html)
            html.inner_html
          end
                
        end
      end
    end
  end
end