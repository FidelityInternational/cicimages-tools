require 'erb'
require 'thor'

require_relative 'instructions'
require_relative 'render_methods'

module Exercise
  class CommandError < StandardError
  end

  class Command < Thor
    BANNER =

      desc 'generate', 'render templates'
    option :quiet, default: false

    def generate
      say <<~MESSAGE
        #############################
        # Generating exercise files #
        #############################
      MESSAGE

      exit 1 unless render_exercises(Dir.pwd)
    end

    no_commands do
      include Instructions
      include RenderMethods

      def quiet?
        options[:quiet]
      end
    end
  end
end
