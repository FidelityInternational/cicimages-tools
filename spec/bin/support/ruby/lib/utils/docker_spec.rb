describe Docker do
  include_context :docker_containers

  subject do
    Object.new.tap do |o|
      o.extend(described_class)
    end
  end

  describe '#container_exists?' do
    context 'container exists' do
      it 'returns true' do
        container_name = create_container
        expect(subject.container_exists?(container_name)).to eq(true)
      end
    end

    context 'container does not exist' do
      it 'returns false' do
        expect(subject.container_exists?(:invalid)).to eq(false)
      end
    end
  end

  describe '#docker_container_running?' do
    context 'container running' do
      it 'returns true' do
        container_name = create_container
        expect(subject.docker_container_running?(container_name)).to eq(true)
      end
    end

    context 'container not running' do
      it 'returns false' do
        expect(subject.docker_container_running?(:invalid)).to eq(false)
      end
    end
  end
end
