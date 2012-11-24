#!/usr/bin/env rake
require "bundler/gem_tasks"

# Rake task for getting an irb session
desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -I lib -r hydra-pbcore.rb"
end