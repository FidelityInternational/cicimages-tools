describe Docker do
  subject do
    Object.new.tap do |o|
      o.extend(described_class)
    end
  end

  describe '#docker' do
    context 'command fails' do
      it 'raises an error' do
        expect { subject.docker('container bad') }.to raise_error(described_class::Error)
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
end
