require 'erb'
require 'thor'
require 'rake'

require_relative 'instructions'
require_relative 'render_methods'

module Exercise
  class CommandError < StandardError
  end

  class Command < Thor
    def self.exit_on_failure?
      true
    end

    desc 'checksum', 'generate checksum'
    option :digest_component, type: :string, required: false, desc: 'value to be considered when generating digest'
    def checksum(template)
      parent_directory = full_path("#{templates_directory(template)}/..")

      say digest(path: parent_directory,
                 digest_component: options[:digest_component],
                 excludes: excluded_files(full_path(template)))
    end

    desc 'generate', 'render templates'
    option :quiet, type: :boolean, default: false
    option :environment_variables, type: :string, required: false
    option :digest_component, type: :string, required: false, desc: 'value to be considered when generating digest'

    def generate(template)
      environment_variables = options[:environment_variables].to_s.scan(%r{([\w+.]+)\s*=\s*([\w+./-]+)?}).to_h
      environment_variables.each do |key, value|
        ENV[key] = value
      end

      template_message = "# Generating template: #{template} #"
      top_and_tail = ''.rjust(template_message.length, '#')
      say "#{top_and_tail}\n#{template_message}\n#{top_and_tail}"

      raise Thor::Error unless render_exercise(template, digest_component: options[:digest_component])
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
        Dir.glob("#{name}/**/*", File::FNM_DOTMATCH).find_all { |file| !%w[. ..].include?(File.basename(file)) }
      end
    end
  end
end
