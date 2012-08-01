require 'scales/up/rails'

desc "Scale up the cache"
Scales::Up.new do |scales|
  
  # Stylesheets
  scales.push :css, :to => "/assets/application.css?body=1"
  scales.push :css, :to => "/assets/scaffolds.css?body=1"
  scales.push :css, :to => "/assets/tracks.css?body=1"
  
  # Javascripts
  scales.push :js, :to => "/assets/jquery.js?body=1"
  scales.push :js, :to => "/assets/jquery_ujs.js?body=1"
  scales.push :js, :to => "/assets/tracks.js?body=1"
  scales.push :js, :to => "/assets/application.js?body=1"
  
  # Images
  scales.push :png, :to => "/assets/rails.png"
  
  # Tracks
  scales.update "/", "/tracks", "/tracks/new", :format => :html
  Track.all.each{ |track| scales.update "/tracks/#{track.id}", "/tracks/#{track.id}/edit", :format => :html }
  
end