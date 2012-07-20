#!/usr/bin/env rake
#require "bundler/gem_tasks"
require 'rspec/core/rake_task'
require './version'

PROJECTS = %w(scales-core scales-server scales-worker)

desc "Run spec task for all projects"
task :spec do
  errors = []
  PROJECTS.each do |project|
    system(%(cd #{project} && #{$0} spec)) || errors << project
  end
  fail("Errors in #{errors.join(', ')}") unless errors.empty?
end
task :default => :spec

desc "Build gem files for all projects"
task :build do
  errors = []
  PROJECTS.each do |project|
    system(%(cd #{project} && #{$0} build)) || errors << project
  end
  fail("Errors in #{errors.join(', ')}") unless errors.empty?
end

desc "Install gems for all projects"
task :install do
  errors = []
  PROJECTS.each do |project|
    system(%(cd #{project} && #{$0} install)) || errors << project
  end
  fail("Errors in #{errors.join(', ')}") unless errors.empty?
end
