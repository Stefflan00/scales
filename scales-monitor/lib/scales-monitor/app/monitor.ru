APP = File.expand_path("../public", __FILE__)

run Proc.new { |env|
  path  = Rack::Utils.unescape(env['PATH_INFO'])
  index = "#{APP}/index.html"
  
  if path == "/"
    [200, {'Content-Type' => 'text/html'}, File.read(index)] if path == "/"
  else
    Rack::Directory.new(APP).call(env)
  end
}