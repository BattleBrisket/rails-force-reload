require 'bundler/gem_tasks'
require 'rake/testtask'
require 'appraisal'
require 'pry'

require 'rails-force-reload/version'

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*test.rb']
end

task :default => :test

namespace :gem do
  desc "Connect to RubyGems.org account"
  task :auth do
    sh "curl -u battlebrisket https://rubygems.org/api/v1/api_key.yaml > ~/.gem/credentials; chmod 0600 ~/.gem/credentials"
  end

  desc "Build the gem according to gemspec"
  task :build do
    sh "gem build rails-force-reload.gemspec"
  end

  desc "Push the gem to RubyGems.org"
  task :push do
    sh "gem push rails-force-reload-#{RailsForceReload::VERSION}.gem"
  end
end

task :publish do
  Rake::Task["gem:build"].invoke
  Rake::Task["gem:push"].invoke
end
