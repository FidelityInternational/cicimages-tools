require 'thor'
require 'open3'
require_relative '../utils/commandline'
require_relative '../utils/docker'
require_relative '../track'

module CIC
  class Command < Thor
    CONTAINER_NOT_RUNNING_MSG = 'Container is not running'.freeze
    CONTAINER_STOPPED_MSG = 'Container stopped'.freeze

    class ContainerAlreadyRunningError < StandardError
    end

    class CICDirectoryMissing < StandardError
    end

    def self.exit_on_failure?
      true
    end

    desc 'track', 'thing'
    subcommand 'track', Track::Command

    desc 'connect [CONTAINER_NAME]', 'log in to a container and see what happened'
    option :command, desc: 'send a command to the container instead of logging in', required: false, default: nil

    def connect(container_name)
      command = "-it #{container_id(container_name)} "
      command << (options[:command] || 'bash -l')
      docker_exec(command)
    end

    desc 'down', 'Bring down environment supporting current exercise'

    def down
      in_cic_directory do
        Commandline::Command.new("#{courseware_environment} docker-compose down").run
        say ok("Environment cic'd down :)")
      end
    rescue Commandline::Command::Error => e
      say error('Failed to cic down the environment see above output for details')
      raise e
    end

    desc 'start IMAGE_TAG', 'log in to a container and see what happened'
    option :map_port, desc: 'map hostport to container port'

    desc 'up', 'Bring up environment to support the current exercise'

    def up
      cic_up_command = "#{courseware_environment} docker-compose up -d --remove-orphans"
      in_cic_directory do
        before_script = './before'
        after_script = './after'

        Commandline::Command.new(before_script).run if File.exist?(before_script)
        Commandline::Command.new(cic_up_command).run
        Commandline::Command.new(after_script).run if File.exist?(after_script)
        say ok("Environment cic'd up :)")
      end
    rescue Commandline::Command::Error => e
      say error('Failed to cic up the environment see above output for details')
      raise e
    end

    no_commands do
      include Commandline::Output
      include Docker
      include Helpers

      private

      def in_cic_directory
        cic_directory = '.cic'
        raise CICDirectoryMissing unless File.exist?(cic_directory)

        Dir.chdir(cic_directory) do
          yield
        end
      end

      def normalise(string)
        string.gsub(%r{[:/]}, '-')
      end

      def start_help_msg(container_name)
        <<-MESSAGE
          Connect with: cic connect #{container_name}
          Stop with   : cic stop #{container_name}
        MESSAGE
      end
    end
  end
end
