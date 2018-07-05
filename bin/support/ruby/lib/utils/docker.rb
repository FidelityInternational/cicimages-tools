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
  def container_exists?(container_name)
    container_id(container_name) && true
  rescue Error
    false
  end



  def docker_container_running?(name)
    result = docker_container_info(name)
    return false if result.empty?
    result.first[:State][:Status] == 'running'
  end

  def container_id(container_name)
    id = docker(%(container ps -q --filter "name=#{container_name}")).stdout
    id.empty? ? raise(Error, "container with name #{container_name} does not exist") : id
  end

  def restart_container(container_name)
    container_id = container_id(container_name)
    docker("container start #{container_id} -i")
  end

  def remove_container(container_name)
    docker "container rm -f #{container_id(container_name)}"
  end

  def create_container(container_name, image_tag, port_mapping: nil)
    network = 'cic'
    port_mapping = port_mapping && "-p #{port_mapping}"
    volume_mapping = '/sys/fs/cgroup:/sys/fs/cgroup:ro'
    cmd = '/sbin/init'
    docker("run --network #{network} -d --privileged --name #{container_name} -v #{volume_mapping} #{port_mapping} #{image_tag} #{cmd}")
  end

  def docker_exec(command)
    system "docker exec #{command}"
  end

  def docker(command)
    command = "docker #{command}"
    puts command
    run(command).tap do |output|
      raise(Error, "Failed to run: #{command}\n#{output}") if output.error?
    end
  end

  def docker_container_info(name)
    JSON(run("docker inspect #{name}").stdout, symbolize_names: true)
  end
end
