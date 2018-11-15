$LOAD_PATH.unshift("#{__dir__}/../bin/support/ruby/lib")
require 'utils/commandline'
module Lint
  extend Commandline
  def self.run_linter(linter)
    result = run "codeclimate analyze -e #{linter} ."
    puts result.stdout
    raise unless result.stdout.include? 'Found 0 issues'
  end
end
