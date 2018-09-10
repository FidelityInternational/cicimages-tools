include Commandline
include Commandline::Output

require 'commands/exercise/render_methods'

require_relative 'support/courseware'

class CourseContentOutOfDateError < StandardError
  def initialize(files)
    error = <<~ERROR
      The following files are out of date and need to be Re-rendered:
      - #{files.collect{|file|File.expand_path(file)}.join("\n- ")}"
    ERROR

    super error
  end
end

class CourseContentRenderingError < StandardError
  def initialize(files)
    error = <<~ERROR
      Unable to render:
      - #{files.collect {|file| File.expand_path(file)}.join("\n- ")}"
    ERROR

    super error
  end
end

def renderer
  Object.new.tap {|o| o.extend(Exercise::RenderMethods)}
end

namespace :course_content do
  desc 'Check that all course_content is based on the latest version of the templates'
  task :checksum, :path do |_t, args|
    path = args[:path] || File.expand_path("#{__dir__}/..")

    out_of_date_files = exercise_directories(path).collect do |templates_dir|
      templates("#{templates_dir}/../")
    end.flatten.collect{|template|renderer.render_file_path(template)}

    raise CourseContentOutOfDateError, out_of_date_files unless out_of_date_files.empty?
  end

  desc 'generate course content from .templates/*.erb templates'
  task :generate, [:mode, :path] do |_task, args|

    path = args[:path] || File.expand_path("#{__dir__}/..")

    failures = exercise_directories(path).collect do |templates_dir|
      parent_directory = "#{templates_dir}/.."
      flags = args[:mode] == 'verbose' ? '' : '--quiet'
      flags << " --environment_variables=exercise_path=#{relative_path("#{templates_dir}/..", root_dir)}"
      flags << " --digest-component=#{Courseware.tag}"

      say "Rendering templates in: #{templates_dir}"
      templates(parent_directory).find_all do |template|
        source = "source #{root_dir}/bin/.env"
        run("#{source} && exercise generate #{template} #{flags}", dir: parent_directory, silent: false).error?
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

  def relative_path(full_path, root)
    ".#{File.expand_path(full_path).gsub(File.expand_path(root), '')}"
  end

  def updated?(template)
    rendered_file = renderer.render_file_path(template)

    excluded_files = renderer.excluded_files(template)
    parent_directory = File.expand_path("#{renderer.templates_directory(template)}/..")
    digest = renderer.digest(path: parent_directory, digest_component: Courseware.tag, excludes: excluded_files)

    return true unless File.exist?(rendered_file)
    !File.read(rendered_file).include?(digest)
  end

  def templates(dir)
    Dir["#{dir}/.templates/*.md.erb"].collect do |template|
      updated?(File.expand_path(template)) ? relative_path(template, dir) : nil
    end.compact
  end
end
