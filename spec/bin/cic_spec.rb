require 'commands/cic'
require 'utils/commandline'
require 'utils/docker'
require 'json'

module Commands
  describe CIC do
    include Commandline
    include Docker

    let(:container_name){'lvlup-ci_course'}
    around do |example|
      example.call
      remove_container(container_name) if docker_container_running?(container_name)
    end

    let(:image) { 'lvlup/ci_course' }
    let(:stdout) { StringIO.new }
    subject do
      stdout = stdout()
      described_class.new.tap do |instance|
        instance.define_singleton_method :output do
          stdout
        end
      end
    end

    describe '#start' do
      it 'starts container in the background' do
        subject.start(image)
        expect(docker_container_running?(container_name)).to eq(true)
      end

      context 'container already running' do
        it 'outputs an error message' do
          subject.start(image)
          expect { subject.start(image) }.to_not raise_error
          expect(docker_container_running?(container_name)).to eq(true)
        end
      end

      context '--map-port' do
        it 'maps the host port to the container port' do
          subject.options = {map_port: '8080:80'}
          subject.start(image)
          expect(`docker port #{container_name}`.chomp).to eq('80/tcp -> 0.0.0.0:8080')
        end
      end
    end

    describe '#stop' do
      context 'container running' do
        it 'stops it' do
          subject.start(image)
          subject.stop(container_name)
          expect(docker_container_running?(container_name)).to eq(false)
          expect(stdout.string).to include(described_class::CONTAINER_STOPPED_MSG)
        end
      end

      context 'container not running' do
        it 'does nothing' do
          expect { subject.stop(container_name) }.to_not raise_error
          expect(stdout.string).to include(described_class::CONTAINER_NOT_RUNNING_MSG)
        end
      end
    end
  end
end
