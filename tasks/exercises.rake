desc 'generate project exercises from .templates/*.erb templates'
task :generate_exercises, :mode do |_task, args|
  quiet = args[:mode] != 'verbose'

  require 'simplecov'
  SimpleCov.start('exercise_generation')

  require 'commands'
  begin
    current_dir = Dir.pwd
    Dir["#{__dir__}/../exercises/**/.templates"].each do |templates_dir|
      Dir.chdir("#{__dir__}/../")
      Exercise::Command.new([], { quiet: quiet }, {}).generate(File.expand_path("#{templates_dir}/.."))
    end
  ensure
    Dir.chdir(current_dir)
  end
end
