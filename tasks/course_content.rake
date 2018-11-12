$LOAD_PATH.unshift("#{__dir__}/../cicimages/tools/bin/support/ruby/lib")
require 'utils/commandline'


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
    checksum(args[:path] || File.expand_path("#{__dir__}/.."))
  end

  desc 'generate course content from .templates/*.erb templates'
  task :generate, %i[mode path] do |_task, args|
    generate(args[:path] || File.expand_path("#{__dir__}/.."))
  end

  def generate(path)
    updated_templates = updated_templates(path)
    puts ""
    failures = updated_templates.find_all do |template|
      options = {environment_variables: "exercise_path=#{template.path}",
                 quiet: args[:mode] != 'verbose'}

      exercise(:generate, template, options, silent: false).error?
    end
    raise CourseContentRenderingError, failures unless failures.empty?
  end

  def checksum(path)
    rendered_files = updated_templates(path).collect(&:rendered_file_path)

    raise CourseContentOutOfDateError, rendered_files unless rendered_files.empty?
  end

  def exercise_directories(path)
    Dir["#{path}/**/.templates"]
  end

  def updated?(template)
    return true unless File.exist?(template.rendered_file_path)

    result = exercise(:checksum, template).stdout
    !File.read(template.rendered_file_path).include?(result)
  end

  def exercise(command, template, options = {}, silent: true)
    options[:digest_component] = Courseware.tag
    options_stirng = options.map {|k, v| "--#{k}=#{v}"}.join
    run("exercise #{command} #{template.path} #{options_stirng}", dir: template.dir, silent: silent)
  end

  def updated_templates(dir)
    exercise_directories(dir).collect do |templates_dir|
      Dir["#{File.expand_path(templates_dir)}/*.md.erb"].collect do |path|
        template = Template.new(path)
        print '.'.green
        updated?(template) ? template : nil
      end
    end.flatten.compact
  end
end
