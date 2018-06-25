require 'commands/cic'
require 'utils/commandline'
require 'utils/docker'
require 'json'

module Commands
  describe CIC do
    include Commandline
    include Docker

    around do |example|
      example.call
      remove_container('lvlup-ci_course') if docker_container_running?('lvlup-ci_course')
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
        expect(docker_container_running?('lvlup-ci_course')).to eq(true)
      end

      context 'container already running' do
        it 'outputs an error message' do
          subject.start(image)
          expect { subject.start(image) }.to_not raise_error
          expect(docker_container_running?('lvlup-ci_course')).to eq(true)
        end
      end
    end

    describe '#stop' do
      context 'container running' do
        it 'stops it' do
          subject.start(image)
          subject.stop('lvlup-ci_course')
          expect(docker_container_running?('lvlup-ci_course')).to eq(false)
          expect(stdout.string).to include(described_class::CONTAINER_STOPPED_MSG)
        end
      end

      context 'container not running' do
        it 'does nothing' do
          expect { subject.stop('lvlup-ci_course') }.to_not raise_error
          expect(stdout.string).to include(described_class::CONTAINER_NOT_RUNNING_MSG)
        end
      end
    end
  end
end
