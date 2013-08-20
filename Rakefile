#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rspec/core/rake_task'

# Rake task for getting an irb session
desc "Open an irb session preloaded with this library"
task :console do
  sh "pry -rubygems -I lib -e \"require 'hydra-pbcore'\""
end

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
