require 'erb'
require 'thor'
require 'rake'
require 'json'

require_relative 'instructions'
require_relative 'render_methods'

module Exercise
  class CourseContentRenderingError < StandardError
    def initialize(files)
      error = <<~ERROR
        Unable to render:
        - #{files.collect { |file| File.expand_path(file) }.join("\n- ")}"
      ERROR

      super error
    end

    def ==(other)
      other.is_a?(CourseContentRenderingError) && message == other.message
    end
  end

  class Path
    attr_reader :full

    def initialize(full_path, project_root)
      @full = full_path
      @project_root = project_root
    end

    def relative
      ".#{File.expand_path(full).gsub(File.expand_path(project_root), '')}"
    end

    private

    attr_reader :project_root
  end

  class Template
    attr_reader :dir, :path, :full_path

    def initialize(path, project_root_dir)
      @full_path = path
      @dir = parent_directory(path)
      @path = relative_path(path, dir)
      @relative_directory = relative_path(dir, project_root_dir)
    end

    def rendered_file_path
      full_path.gsub(%r{.templates/.*?erb}, filename).gsub('.erb', '')
    end

    def filename
      File.basename(path)
    end

    def relative_path(full_path, root)
      ".#{File.expand_path(full_path).gsub(File.expand_path(root), '')}"
    end

    private

    def parent_directory(dir)
      File.expand_path("#{File.dirname(dir)}/..").to_s
    end
  end

  class CommandError < StandardError
  end

  module Helpers
    include RenderMethods

    def all_files_in(name)
      Dir.glob("#{name}/**/*", File::FNM_DOTMATCH).find_all { |file| !%w[. ..].include?(File.basename(file)) }
    end

    def all_updated(paths, project_root_dir)
      paths.find_all { |path| template_updated?(path, project_root_dir) }.collect do |template|
        Template.new(template, project_root_dir)
      end
    end

    def exercise_structure
      @exercise_structure ||= YAML.safe_load(File.read(ENV['SCAFFOLD_STRUCTURE']))
    end

    def exercise_directories(path)
      Dir["#{path}/**/.templates"]
    end

    def print_rendering_banner(template_path)
      template_message = "# Generating template: #{template_path} in path: #{ENV['exercise_path']} #"
      top_and_tail = ''.rjust(template_message.length, '#')
      say "#{top_and_tail}\n#{template_message}\n#{top_and_tail}"
    end

    def process_template(original_dir, template)
      template_dir = template.dir
      Dir.chdir template_dir
      ENV['exercise_path'] = template_dir.gsub(original_dir, '')
      # ENV['CIC_PWD'] = "#{ENV['CIC_PWD']}/#{template.relative_path(template_dir, original_dir)}"
      print_rendering_banner(template.path)
      !render_exercise(template.path, digest_component: options[:digest_component])
    ensure
      # ENV['CIC_PWD'] = original_dir
      Dir.chdir original_dir
    end

    def quiet?
      options[:verbose] == false
    end

    def scaffold_path
      @scaffold_path ||= ENV['SCAFFOLD_PATH']
    end

    def register_environment(environment_variables_string)
      environment_variables = environment_variables_string.to_s.scan(%r{([\w+.]+)\s*=\s*([\w+./-]+)?}).to_h
      environment_variables.each { |key, value| ENV[key] = value }
    end

    def templates(path)
      exercise_directories(path).collect do |templates_dir|
        Dir["#{File.expand_path(templates_dir)}/*.md.erb"]
      end.flatten
    end

    def template_updated?(template, project_root_dir)
      template = template.is_a?(String) ? Template.new(template, project_root_dir) : template

      return true unless File.exist?(template.rendered_file_path)

      digest = digest(path: template.dir,
                      digest_component: options[:digest_component],
                      excludes: excluded_files(template.full_path))

      !File.read(template.rendered_file_path).include?(digest)
    end
  end

  class Command < Thor
    def self.exit_on_failure?
      true
    end

    desc 'requiring_update', 'generate checksum'
    option :digest_component,
           type: :string,
           required: false,
           default: '',
           desc: 'value to be considered when generating digest'

    def requiring_update(path = '.')
      directories = if File.directory?(path)
                      templates(path)
                    else
                      [template]
                    end

      results = directories.find_all do |temp|
        template_updated?(temp, Dir.pwd)
      end.flatten

      say results.to_json
    end

    desc 'generate', 'render templates'
    option :verbose, type: :boolean, default: false
    option :environment_variables, type: :string, required: false
    option :digest_component,
           type: :string,
           required: false,
           desc: 'value to be considered when generating digest',
           default: ''

    def generate(path = '.')
      register_environment(options[:environment_variables])

      templates = File.directory?(path) ? templates(path) : [path]

      original_dir = Dir.pwd
      failures = all_updated(templates, original_dir).find_all do |template|
        process_template(original_dir, template)
      end

      raise CourseContentRenderingError, failures.collect(&:path) unless failures.empty?
    end

    desc 'create <NAME>', 'create a new exercise'

    def create(name)
      say "Creating new exercise: #{name}"
      FileUtils.mkdir_p(name)

      exercise_structure['directories'].each do |directory|
        FileUtils.mkdir_p("#{name}/#{directory}")
      end

      FileUtils.cp_r("#{scaffold_path}/.", name)

      all_files_in(name).each { |path| say "Created: #{path}" }

      say ok 'Complete'
    end

    no_commands do
      include Helpers
    end
  end
end
