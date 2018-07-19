desc 'generate project exercises from .templates/*.erb templates'
task :generate_exercises, :mode do |_task, args|
  flag = args[:mode] == 'verbose' ? '' : '--quiet'
  result = true
  Dir["#{__dir__}/../exercises/**/.templates"].each do |templates_dir|
    result = false unless system "bash -c 'source #{__dir__}/../bin/.env && cd #{templates_dir}/.. && exercise generate #{flag}'"
  end
  raise "failed to generate exercises" unless result
end
