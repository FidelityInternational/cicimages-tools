# frozen_string_literal: true

require 'bundler'
Bundler.require :development, :default

import "#{__dir__}/tasks/lint.rake"
import "#{__dir__}/tasks/exercises.rake"

RSpec::Core::RakeTask.new(:spec) do
  ENV['COVERAGE'] = 'true'
end

task :clean do
  require 'fileutils'
  FileUtils.rm_rf("#{__dir__}/coverage")
end

require 'pty'
task :build_courseware do
  image = File.read("#{__dir__}/.courseware-image")
  version = File.read("#{__dir__}/.courseware-version")

  stdout, _stdin, _pid = PTY.spawn "docker build #{__dir__} -t #{image}:#{version}"
  while (string = stdout.gets)
    puts string
  end
end

default_tasks = %i[clean spec generate_exercises rubocop shellcheck coverage_check]
desc default_tasks.join(',')
task default: default_tasks
