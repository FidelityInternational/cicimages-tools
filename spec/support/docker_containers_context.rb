shared_context :docker_containers do
  around :each do |spec|
    spec.call
    containers.each do |container|
      subject.remove_container(container)
    end
  end

  def containers
    @containers ||= []
  end

  def create_container
    container_name = rand(999_999)
    subject.create_container(container_name, 'lvlup/ci_course')
    containers << container_name
    container_name
  end
end
