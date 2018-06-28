SimpleCov.add_group 'Commands', 'commands'
SimpleCov.add_group 'utils', 'utils'


SimpleCov.profiles.define 'rspec' do
  add_filter "/spec/"
end

SimpleCov.profiles.define 'exercise_generation' do
end