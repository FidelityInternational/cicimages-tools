# frozen_string_literal: true

require 'bundler'
Bundler.require :development, :default
$LOAD_PATH.unshift("#{__dir__}/tasks/support")

require 'courseware'

Dir["#{__dir__}/tasks/*.rake"].each { |tasks| import tasks }

Courseware.init(version_file: "#{__dir__}/VERSION", repository: 'cicimages/tools')

desc 'run this on checkout to pull drown required docker images'
task :init do
  run('docker-compose pull', silent: false)
end

RSpec::Core::RakeTask.new(:spec) do
  ENV['COVERAGE'] = 'true'
end

YARD::Rake::YardocTask.new

task :clean do
  require 'fileutils'
  FileUtils.rm_rf("#{__dir__}/coverage")
end

default_tasks = %i[clean spec rubocop shellcheck coverage_check yard]
desc default_tasks.join(',')
task default: default_tasks
