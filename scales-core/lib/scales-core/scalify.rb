module Scales
  class Scalify < Thor::Group
    include Thor::Actions

    def self.source_root
      File.expand_path "../scalify/templates", __FILE__
    end

    def create_scaleup_file
      template 'scaleup.rb', "config/scaleup.rb"
    end

    def create_cache_file
      template 'cache.yml', "config/cache.yml"
    end
  end
end