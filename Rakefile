#!/usr/bin/env rake
#require "bundler/gem_tasks"
require 'rspec/core/rake_task'
require './version'

PROJECTS = %w(scales-core scales-server scales-worker scales-monitor)

RSpec::Core::RakeTask.new(:integration) do |rspec|
  rspec.rspec_opts = "-f d", "--color"
end

desc "Run spec task for all projects"
task :spec do
  errors = []
  PROJECTS.each do |project|
    system(%(cd #{project} && SCALES_ENV=test #{$0} spec))      || errors << project
  end
  system(%(cd #{Dir.pwd} && SCALES_ENV=test #{$0} integration)) || errors << "integration"
  system(%(cd #{Dir.pwd}/spec/app && rails runner -e test "Track.destroy_all"))
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

desc 'Bump all versions to match version.rb'
task :update_versions do
  require File.dirname(__FILE__) + "/version"

  PROJECTS.each do |project|
    Dir["#{project}/lib/*/version.rb"].each do |file|
      version_file = File.read(file)
      version_file.gsub! /VERSION = \".+\"/, "VERSION = \"#{Scales::VERSION}\""
      File.write(file, version_file)
    end
  end
  puts "Updated to #{Scales::VERSION}"
end
