require 'rake'
require './lib/manage_meta/version'

# snarf gemspec and set version
manage_meta_version = ManageMeta::VERSION.to_s

task :default => :test

desc "Run ManageMeta unit tests"
task :test do
  puts "Version: #{manage_meta_version}"
  require './test/manage_meta_test'
end

desc "build README"
task :readme do
  system "sed -e s/VERSION/#{manage_meta_version}/ README.markdown.src >README.markdown"
end

desc "build gem"
task :gem => :readme do
  system 'gem build manage_meta.gemspec'
end

desc "prep for distributions"
task :prep => :readme do
  puts "push it by hand - in case you are on a branch or something"
end
