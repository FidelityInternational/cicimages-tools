include Commandline
include Commandline::Output

class CourseContentOutOfDateError < StandardError
  def initialize(files)
    error = <<~ERROR
      The following files are out of date and need to be Re-rendered:
      - #{files.join("\n- ")}"
    ERROR

    super error
  end
end

class CourseContentRenderingError < StandardError
  def initialize(files)
    error = <<~ERROR
      Unable to render:
      - #{files.collect { |file| File.expand_path(file) }.join("\n- ")}"
    ERROR

    super error
  end
end

namespace :course_content do
  desc 'Check that all course_content is based on the latest version of the templates'
  task :checksum, :path do |_t, args|
    path = args[:path] || File.expand_path("#{__dir__}/..")

    out_of_date_files = exercise_directories(path).collect do |templates_dir|
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
  task :generate, [:mode, :path] do |_task, args|
    flag = args[:mode] == 'verbose' ? '' : '--quiet'
    path = args[:path] || File.expand_path("#{__dir__}/..")

    failures = exercise_directories(path).collect do |templates_dir|
      say "Rendering templates in: #{templates_dir}"
      parent_directory = "#{templates_dir}/.."
      templates(parent_directory).find_all do |template|
        source = "source #{root_dir}/bin/.env"
        run("#{source} && exercise generate #{template} #{flag}", dir: parent_directory, silent: false).error?
      end
    end.flatten
    raise CourseContentRenderingError, failures unless failures.empty?
  end

  def exercise_directories(path)
    Dir["#{path}/**/.templates"]
  end

  def root_dir
    "#{__dir__}/../"
  end

  def templates(dir)
    Dir["#{dir}/.templates/*.md.erb"].collect do |template|
      template.gsub("#{File.expand_path(dir)}/", './')
    end
  end
end
