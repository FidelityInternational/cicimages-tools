require 'utils/docker'
shared_context :docker_containers do
  include Docker

  around :each do |spec|
    spec.call
    containers.each do |container|
      remove_container(container)
    end
  end

  def containers
    @containers ||= []
  end

  alias_method :create_container_backup, :create_container
  def create_container
    container_name = rand(999_999)
    create_container_backup(container_name, 'lvlup/ci_course')
    containers << container_name
    container_name
  end

  def container_exists?(container_name)
    container_id(container_name) && true
  rescue Error
    false
  end
end
