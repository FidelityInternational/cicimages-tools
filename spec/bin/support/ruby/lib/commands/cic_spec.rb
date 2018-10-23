require 'commands/cic'
require 'utils/commandline'
require 'utils/docker'
require 'json'

module Commands
  module CIC
    describe Command do
      include Commandline
      include Docker

      include_context :command

      let(:container_name) { 'lvlup-ci_course' }
      let(:image) { 'lvlup/ci_course' }

      around do |example|
        example.call
        remove_container(container_name) if docker_container_running?(container_name)
      end

      it 'has a track subcommand' do
        expect(described_class.subcommand_classes['track']).to be(Track::Command)
      end

      describe '#connect' do
        context 'command option specified' do
          it 'runs the command against the container' do
            subject.options = { command: 'command' }
            expect(subject).to receive(:container_id).with('container').and_return(:container_id)
            expect(subject).to receive(:docker_exec).with("-it #{:container_id} command")
            subject.connect('container')
          end
        end

        it 'connects to the given container' do
          expect(subject).to receive(:container_id).with('container').and_return(:container_id)
          expect(subject).to receive(:docker_exec).with("-it #{:container_id} bash -l")
          subject.connect('container')
        end
      end

      context 'up and down' do
        let(:courseware_version) { 'version' }
        let(:courseware_image) { 'image' }

        before do
          ENV['CIC_COURSEWARE_VERSION'] = courseware_version
          ENV['CIC_COURSEWARE_IMAGE'] = courseware_image
          FileUtils.mkdir('.cic')
        end

        describe '#down' do
          it_behaves_like :command_wrapper, 'docker-compose down', :down do
            let(:expected_environment) do
              "CIC_COURSEWARE_VERSION=#{courseware_version} CIC_COURSEWARE_IMAGE=#{courseware_image} CIC_PWD="
            end
          end

          context '.cic directory missing' do
            it 'raises an error' do
              FileUtils.rm_rf('.cic')
              expect { subject.down }.to raise_error(described_class::CICDirectoryMissing)
            end
          end
        end

        describe '#up' do
          it_behaves_like :command_wrapper, 'docker-compose up -d --remove-orphans', :up do
            let(:expected_environment) do
              "CIC_COURSEWARE_VERSION=#{courseware_version} CIC_COURSEWARE_IMAGE=#{courseware_image} CIC_PWD="
            end
          end

          context '.cic directory missing' do
            it 'raises an error' do
              FileUtils.rm_rf('.cic')
              expect { subject.up }.to raise_error(described_class::CICDirectoryMissing)
            end
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
            subject.options = { map_port: '8080:80' }
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
end
