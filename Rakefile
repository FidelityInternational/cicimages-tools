# frozen_string_literal: true

require 'bundler'
Bundler.require :development, :default

import "#{__dir__}/tasks/lint.rake"
import "#{__dir__}/tasks/exercises.rake"
import "#{__dir__}/tasks/courseware.rake"

RSpec::Core::RakeTask.new(:spec) do
  ENV['COVERAGE'] = 'true'
end

task :clean do
  require 'fileutils'
  FileUtils.rm_rf("#{__dir__}/coverage")
end

default_tasks = %i[clean spec generate_exercises rubocop shellcheck coverage_check]
desc default_tasks.join(',')
task default: default_tasks
