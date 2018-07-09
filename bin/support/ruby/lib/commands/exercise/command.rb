require 'erb'
require 'thor'

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

    def generate(path=Dir.pwd)
      say <<~MESSAGE
        #############################
        # Generating exercise files #
        #############################
      MESSAGE

      raise Thor::Error unless render_exercises(path)
    end

    no_commands do
      include RenderMethods

      def quiet?
        options[:quiet] == true
      end
    end
  end
end
