$LOAD_PATH.unshift("#{__dir__}/../bin/support/ruby/lib")
$LOAD_PATH.unshift("#{__dir__}/support")

require 'docker_containers_context'

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start('rspec')
end
require 'commands'
