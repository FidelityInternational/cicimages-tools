$LOAD_PATH.unshift("#{__dir__}/../../lib")
require 'utils/commandline'
module Lint
  extend Commandline
  def self.run_linter(linter)
    result = run "codeclimate analyze -e #{linter} .", silent: false
    raise unless result.stdout.include? 'Found 0 issues'
  end
end
