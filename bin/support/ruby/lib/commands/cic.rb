require 'thor'
require 'open3'
require_relative '../utils/commandline'
require_relative '../utils/docker'
require_relative 'track'

module Commands
  class CIC < Thor
    CONTAINER_NOT_RUNNING_MSG = 'Container is not running'.freeze
    CONTAINER_STOPPED_MSG = 'Container stopped'.freeze

    class ContainerAlreadyRunningError < StandardError
    end

    desc 'track', 'thing'
    subcommand 'track', Track

    desc 'connect [CONTAINER_NAME]', 'log in to a container and see what happened'
    option :command, desc: 'send a command to the container instead of logging in', required: false, default: nil
    def connect(container_name)
      command = "-it #{container_name} "
      command << (options[:command] || 'bash -l')
      docker_exec(command)
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

    no_commands do
      include Commandline::Output
      include Docker

      private

      def start_help_msg(container_name)
        <<-MESSAGE
          Connect with: cic connect #{container_name}
          Stop with   : cic stop #{container_name}
        MESSAGE
      end

      def normalise(string)
        string.gsub(%r{[:/]}, '-')
      end
    end
  end
end
