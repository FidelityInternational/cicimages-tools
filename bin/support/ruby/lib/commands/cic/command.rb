require 'thor'
require 'open3'
require_relative '../../utils/commandline'
require_relative '../../utils/docker'
require_relative '../track'

module Commands
  module CIC
    class Command < Thor
      CONTAINER_NOT_RUNNING_MSG = 'Container is not running'.freeze
      CONTAINER_STOPPED_MSG = 'Container stopped'.freeze

      class ContainerAlreadyRunningError < StandardError
      end

      class CICDirectoryMissing < StandardError
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
          execute "#{courseware_environment} docker-compose down",
                  pass_message: "Environment cic'd down :)",
                  fail_message: 'Failed to cic down the environment see above output for details'
        end
      end

      desc 'start IMAGE_TAG', 'log in to a container and see what happened'
      option :map_port, desc: 'map hostport to container port'

      def start(image_tag)
        container_name = normalise(image_tag)

        msg = if docker_container_running?(container_name)
                'Container already running (any supplied options ignored)'
              else
                create_container(container_name, image_tag, port_mapping: options[:map_port])
                'Starting container'
              end

        say ok "#{msg}\n#{start_help_msg(container_name)}"
      end

      desc 'stop[CONTAINER_NAME]', 'Stop running container'

      def stop(container_name)
        if docker_container_running?(container_name)
          remove_container(container_name)
          say ok CONTAINER_STOPPED_MSG
        else
          say ok CONTAINER_NOT_RUNNING_MSG
        end
      end

      desc 'up', 'Bring up environment to support the current exercise'

      def up
        in_cic_directory do
          commands = ["#{courseware_environment} docker-compose up -d --remove-orphans"]

          before_script = 'before'
          commands << "./#{before_script}" if File.exist?(before_script)

          after_script = 'after'
          commands << "./#{after_script}" if File.exist?(after_script)

          execute(*commands,
                  pass_message: "Environment cic'd up :)",
                  fail_message: 'Failed to cic up the environment see above output for details')
        end
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
end
