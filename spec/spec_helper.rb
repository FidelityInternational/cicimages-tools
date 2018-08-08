$LOAD_PATH.unshift("#{__dir__}/../bin/support/ruby/lib")
$LOAD_PATH.unshift("#{__dir__}/support")

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start('rspec')
end

require 'shared_contexts'
require 'shared_examples/command_wrapper_examples'

require 'commands'

RSpec.configure do |config|
  config.include_context :run_in_temp_directory
  config.include_context :clean_env
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
