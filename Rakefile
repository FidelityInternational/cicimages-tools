# frozen_string_literal: true

$LOAD_PATH.unshift("#{__dir__}/bin/support/ruby/lib")
require 'commands/exercise/command'
require 'utils/commandline'

module Lint
  extend Commandline

  def self.run_linter(linter)
    result = run "codeclimate analyze -e #{linter} ."
    puts result.stdout
    raise unless result.stdout.include? 'Found 0 issues'
  end
end

default_tasks = %i[generate_exercises rubocop shellcheck]
desc default_tasks.join(',')
task default: default_tasks

desc 'lint project shellscripts'
task :shellcheck do
  Lint.run_linter(:shellcheck)
end

desc 'lint project ruby source code'
task :rubocop do
  Lint.run_linter(:rubocop)
end

desc 'generate project exercises from .templates/*.erb templates'
task :generate_exercises, :mode do |_task, args|
  quiet = args[:mode] != 'verbose'
  begin
    current_dir = Dir.pwd
    Dir["#{__dir__}/exercises/**/.templates"].each do |templates_dir|
      Dir.chdir("#{templates_dir}/..")
      Exercise::Command.new([], { quiet: quiet }, {}).generate
    end
  ensure
    Dir.chdir(current_dir)
  end
end
