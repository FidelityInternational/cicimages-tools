describe Docker do
  include_context :docker_containers

  subject do
    Object.new.tap do |o|
      o.extend(described_class)
    end
  end

  describe '#docker' do
    context 'command fails' do
      it 'raises an error' do
        expect { subject.docker('bad') }.to raise_error(described_class::Error)
      end
    end
  end

  describe '#docker exec' do
    it 'executes the given command' do
      command = 'command'
      expect(subject).to receive(:system).with("docker exec #{command}")
      subject.docker_exec(command)
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
