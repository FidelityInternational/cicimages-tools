SimpleCov.add_group 'Commands', 'commands'
SimpleCov.add_group 'utils', 'utils'


SimpleCov.profiles.define 'rspec' do
  command_name 'rspec'
  add_filter "/spec/"
end

SimpleCov.profiles.define 'exercise_generation' do
    command_name 'exercise_generation'
    add_filter "/spec/"
end