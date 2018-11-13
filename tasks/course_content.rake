$LOAD_PATH.unshift("#{__dir__}/../cicimages/tools/bin/support/ruby/lib")
require 'utils/commandline'
require 'json'

require_relative '../cicimages/tools/tasks/support/courseware'

class CourseContentOutOfDateError < StandardError
  def initialize(files)
    error = <<~ERROR
      The following files are out of date and need to be Re-rendered:
      - #{files.collect {|file| File.expand_path(file)}.join("\n- ")}"
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

class Template
  attr_reader :dir, :path, :full_path

  def initialize (path)
    @full_path = path
    @dir = parent_directory(path)
    @path = relative_path(path, dir)
  end

  def rendered_file_path
    full_path.gsub(%r{.templates/.*?erb}, filename).gsub('.erb', '')
  end

  def filename
    File.basename(path)
  end

  private

  def parent_directory(dir)
    File.expand_path("#{File.dirname(dir)}/..").to_s
  end

  def relative_path(full_path, root)
    ".#{File.expand_path(full_path).gsub(File.expand_path(root), '')}"
  end
end


namespace :course_content do
  include Commandline
  include Commandline::Output

  desc 'Check that all course_content is based on the latest version of the templates'
  task :checksum, :path do |_t, args|
    results = updated_templates(args[:path] || File.expand_path("#{__dir__}/.."))
    raise CourseContentOutOfDateError, results unless results.empty?
  end

  desc 'generate course content from .templates/*.erb templates'
  task :generate, %i[mode path] do |_task, args|
    working_directory = args[:path] || File.expand_path("#{__dir__}/..")

    updated_templates = updated_templates(working_directory)
    puts ""
    failures = updated_templates.find_all do |template|
      options = {environment_variables: "exercise_path=#{template.path}",
                 quiet: args[:mode] != 'verbose'}

      exercise(:generate, template.path, options, path: working_directory, silent: false).error?
    end
    raise CourseContentRenderingError, failures unless failures.empty?
  end

  def exercise(command, template, options = {}, path:, silent: true)
    options[:digest_component] = Courseware.tag
    options_stirng = options.map {|k, v| "--#{k}=#{v}"}.join
    command = "exercise #{command} #{template} #{options_stirng}"
    run(command, dir: path, silent: silent)
  end

  def updated_templates(dir)
    result = exercise(:updated?, '.', path: dir)
    JSON.parse(result.stdout).collect{|template| Template.new(template)}
  end
end
