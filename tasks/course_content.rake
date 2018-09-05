class CourseContentOutOfDateError < StandardError
  def initialize(files)
    error = <<~ERROR
      The following files are out of date and need to be Re-rendered:
      - #{files.join("\n- ")}"
ERROR

    super error
  end
end

namespace :course_content do
  desc 'Check that all course_content is based on the latest version of the templates'
  task :checksum, :path do |_t, args|
    path = args[:path] || File.expand_path("#{__dir__}/..")

    out_of_date_files = Dir["#{path}/**/.templates"].collect do |templates_dir|
      render_dir = File.expand_path("#{templates_dir}/..")
      templating_extension = '.erb'

      Dir["#{templates_dir}/**/*#{templating_extension}"].collect do |template|
        expected_revision = Digest::SHA2.file(template).hexdigest

        rendered_file_path = "#{render_dir}/#{File.basename(template, templating_extension)}"
        rendered_file_content = File.read(rendered_file_path)
        rendered_file_content.lines.last.end_with?(expected_revision) ? nil : rendered_file_path
      end.compact
    end.flatten

    raise CourseContentOutOfDateError, out_of_date_files unless out_of_date_files.empty?
  end

  desc 'generate course content from .templates/*.erb templates'
  task :generate, :mode do |_task, args|
    flag = args[:mode] == 'verbose' ? '' : '--quiet'
    result = true
    root_dir = File.expand_path("#{__dir__}/..")

    Dir["#{root_dir}/**/.templates"].each do |templates_dir|
      exercise_dir = File.expand_path("#{templates_dir}/..")
      puts "Rendering templates for: #{exercise_dir}"
      pretty_exercise_path = exercise_dir.gsub(root_dir, '').gsub(%r{^/}, '')
      exercise_command = "exercise generate #{flag} --pretty-exercise-path=#{pretty_exercise_path}"
      command = "bash -c 'source #{root_dir}/bin/.env && cd #{exercise_dir} && #{exercise_command}'"
      result = false unless system command
    end
    raise 'failed to generate exercises' unless result
  end
end
