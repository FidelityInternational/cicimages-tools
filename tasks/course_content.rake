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
end
