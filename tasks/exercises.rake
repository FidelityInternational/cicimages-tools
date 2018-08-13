desc 'generate project exercises from .templates/*.erb templates'
task :generate_course_content, :mode do |_task, args|
  flag = args[:mode] == 'verbose' ? '' : '--quiet'
  result = true
  root_dir = File.expand_path("#{__dir__}/..")

  Dir["#{root_dir}/**/.templates"].each do |templates_dir|
    exercise_dir = File.expand_path("#{templates_dir}/..")
    pretty_exercise_path = exercise_dir.gsub(root_dir, '').gsub(%r{^/}, '')
    exercise_command = "exercise generate #{flag} --pretty-exercise-path=#{pretty_exercise_path}"
    command = "bash -c 'source #{root_dir}/bin/.env && cd #{exercise_dir} && #{exercise_command}'"
    result = false unless system command
  end
  raise 'failed to generate exercises' unless result
end
