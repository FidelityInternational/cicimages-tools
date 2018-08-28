# frozen_string_literal: true

require 'bundler'
Bundler.require :development, :default

Dir["#{__dir__}/tasks/*.rake"].each { |tasks| import tasks }

RSpec::Core::RakeTask.new(:spec) do
  ENV['COVERAGE'] = 'true'
end

YARD::Rake::YardocTask.new

task :clean do
  require 'fileutils'
  FileUtils.rm_rf("#{__dir__}/coverage")
end

default_tasks = %i[clean spec course_content:checksum rubocop shellcheck coverage_check yard]
desc default_tasks.join(',')
task default: default_tasks
