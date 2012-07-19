#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rspec/core/rake_task'

PROJECTS = %w(scales-core scales-server scales-worker)

desc "Run spec task for all projects"
task :spec do
  errors = []
  PROJECTS.each do |project|
    system(%(cd #{project} && #{$0} #{task_name})) || errors << project
  end
  fail("Errors in #{errors.join(', ')}") unless errors.empty?
end
task :default => :spec

