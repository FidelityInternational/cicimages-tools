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
      - #{files.collect {|file| File.expand_path(file)}.join("\n- ")}"
      ERROR

      super error
    end


    def == other
      other.is_a?(CourseContentRenderingError) && self.message == other.message
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


  class CommandError < StandardError
  end

  class Command < Thor
    def self.exit_on_failure?
      true
    end

    desc 'checksum', 'generate checksum'
    option :digest_component, type: :string, required: false, desc: 'value to be considered when generating digest'

    def checksum(template)
      template = Template.new(template)

      say digest(path: template.dir,
                 digest_component: options[:digest_component],
                 excludes: excluded_files(template.full_path))
    end

    desc 'updated', 'generate checksum'
    option :digest_component, type: :string, required: false, desc: 'value to be considered when generating digest'

    def requiring_updated(path)

      if File.directory?(path)
        directories = templates(path)
      else
        directories = [template]
      end


      results = directories.find_all do |temp|
        template_updated?(temp)
      end.flatten

      say results.to_json
    end

    desc 'generate', 'render templates'
    option :quiet, type: :boolean, default: false
    option :environment_variables, type: :string, required: false
    option :digest_component, type: :string, required: false, desc: 'value to be considered when generating digest'

    def generate(path)
      set_environment(options[:environment_variables])

      templates = File.directory?(path) ? templates(path) : [path]


      original_dir = Dir.pwd
      failures = templates.find_all {|template| template_updated?(template)}.find_all do |template|

        template = Template.new(template)
        ENV['exercise_path'] = template.dir.gsub(original_dir, '')

        Dir.chdir template.dir
        template_message = "# Generating template: #{template.path} in path: #{ENV['exercise_path']} #"
        top_and_tail = ''.rjust(template_message.length, '#')
        say "#{top_and_tail}\n#{template_message}\n#{top_and_tail}"
        begin
          !render_exercise(template.path, digest_component: options[:digest_component])
        ensure
          Dir.chdir original_dir
        end
      end

      raise CourseContentRenderingError.new(failures) unless failures.empty?
    end

    desc 'create <NAME>', 'create a new exercise'

    def create(name)
      say "Creating new exercise: #{name}"
      FileUtils.mkdir_p(name)

      exercise_structure['directories'].each do |directory|
        FileUtils.mkdir_p("#{name}/#{directory}")
      end

      FileUtils.cp_r("#{scaffold_path}/.", name)

      all_files_in(name).each do |path|
        say "Created: #{path}"
      end
      say ok 'Complete'
    end

    no_commands do
      include RenderMethods

      def exercise_directories(path)
        Dir["#{path}/**/.templates"]
      end

      def template_updated?(template)
        template = template.is_a?(String) ? Template.new(template) : template

        return true unless File.exist?(template.rendered_file_path)

        digest = digest(path: template.dir,
                        digest_component: options[:digest_component],
                        excludes: excluded_files(template.full_path))

        !File.read(template.rendered_file_path).include?(digest)
      end

      def quiet?
        options[:quiet] == true
      end

      def exercise_structure
        @exercise_structure ||= YAML.safe_load(File.read(ENV['SCAFFOLD_STRUCTURE']))
      end

      def scaffold_path
        @scaffold_path ||= ENV['SCAFFOLD_PATH']
      end

      def all_files_in(name)
        Dir.glob("#{name}/**/*", File::FNM_DOTMATCH).find_all {|file| !%w[. ..].include?(File.basename(file))}
      end

      def set_environment(environment_variables_string)
        environment_variables = environment_variables_string.to_s.scan(%r{([\w+.]+)\s*=\s*([\w+./-]+)?}).to_h
        environment_variables.each do |key, value|
          ENV[key] = value
        end
      end

      def templates(path)
        exercise_directories(path).collect do |templates_dir|
          Dir["#{File.expand_path(templates_dir)}/*.md.erb"]
        end.flatten
      end
    end
    private




  end
end
