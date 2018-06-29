$LOAD_PATH.unshift("#{__dir__}/../bin/support/ruby/lib")
if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start('rspec')
end
require 'commands'
