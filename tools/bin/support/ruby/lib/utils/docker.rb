# frozen_string_literal: true

require_relative 'commandline'
require 'json'
module Docker
  class Error < StandardError
    include Commandline::Output
    def initialize(msg)
      super error(msg)
    end
  end

  include Commandline

  def container_id(container_name)
    id = docker(%(container ps -q --filter "name=#{container_name}")).stdout
    id.empty? ? raise(Error, "container with name #{container_name} does not exist") : id
  end

  def docker_exec(command)
    system "docker exec #{command}"
  end

  def docker(command)
    command = "docker #{command}"
    run(command).tap do |output|
      raise(Error, "Failed to run: #{command}\n#{output}") if output.error?
    end
  end
end
