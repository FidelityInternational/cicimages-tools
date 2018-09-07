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

    desc 'generate', 'render templates'
    option :quiet, type: :boolean, default: false
    def generate(template)
      say <<~MESSAGE
        ####################################
        # Generating template: #{template} #
        ####################################
      MESSAGE

      raise Thor::Error unless render_exercise(template)
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
