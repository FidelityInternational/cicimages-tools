# frozen_string_literal: true

require 'bundler'
Bundler.require :development, :default
$LOAD_PATH.unshift("#{__dir__}/tasks/support")

require 'courseware'

Dir["#{__dir__}/tasks/*.rake"].each { |tasks| import tasks }

Courseware.init(version_file: "#{__dir__}/VERSION", repository: 'cicimages/tools')

desc 'run this on checkout to pull drown required docker images'
task :init do
  Dir.chdir "#{__dir__}/support" do
    run('docker-compose pull', silent: false)
  end
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

Jeweler::Tasks.new do |gem|
  gem.name = 'cic-tools'
  gem.homepage = 'https://github.com/FidiletyInternational/cicimages-tools'
  gem.license = 'Apache 2.0'
  gem.summary = 'cictools'
  gem.description = 'cic tools'
  gem.email = 'info@lvl-up.uk'
  gem.authors = ['Leon Davis']
  gem.required_ruby_version = '>= 2.3'
  gem.files = Dir.glob(%w[lib/**/*.rb bin/*])
  gem.executables = %w[cic exercise]
end

Jeweler::RubygemsDotOrgTasks.new
