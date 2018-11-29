require 'cic'
require 'utils/commandline'
require 'utils/docker'
require 'json'

module CIC
  describe Command do
    include Commandline
    include Docker

    include_context :command

    it 'has a track subcommand' do
      expect(described_class.subcommand_classes['track']).to be(Track::Command)
    end

    describe '#connect' do
      context 'command option specified' do
        it 'runs the command against the container' do
          subject.options = {command: 'command'}
          expect(subject).to receive(:container_id).with('container').and_return(:container_id)
          expect(subject).to receive(:docker_exec).with('-it container_id command')
          subject.connect('container')
        end
      end

      it 'connects to the given container' do
        expect(subject).to receive(:container_id).with('container').and_return(:container_id)
        expect(subject).to receive(:docker_exec).with('-it container_id bash -l')
        subject.connect('container')
      end
    end

    context 'up and down' do
      let(:courseware_version) {'version'}
      let(:courseware_image) {'image'}

      before do
        ENV['CIC_COURSEWARE_VERSION'] = courseware_version
        ENV['CIC_COURSEWARE_IMAGE'] = courseware_image
        FileUtils.mkdir('.cic')
      end

      describe '#down' do
        it_behaves_like :command_wrapper, 'docker-compose down', :down do
          let(:expected_environment) do
            "CIC_COURSEWARE_VERSION=#{courseware_version} CIC_COURSEWARE_IMAGE=#{courseware_image} CIC_PWD=#{Dir.pwd}/.cic"
          end
        end

        context 'a command fails' do
          pending 'raises an error'
        end

        context '.cic directory missing' do
          it 'raises an error' do
            FileUtils.rm_rf('.cic')
            expect {subject.down}.to raise_error(described_class::CICDirectoryMissing)
          end
        end
      end

      describe '#up' do
        it_behaves_like :command_wrapper, 'docker-compose up -d --remove-orphans', :up do
          let(:expected_environment) do
            "CIC_COURSEWARE_VERSION=#{courseware_version} CIC_COURSEWARE_IMAGE=#{courseware_image} CIC_PWD=#{Dir.pwd}"
          end
        end

        pending 'supports hooks'

        context 'a command fails' do
          pending 'raises an error'
        end

        context '.cic directory missing' do
          it 'raises an error' do
            FileUtils.rm_rf('.cic')
            expect {subject.up}.to raise_error(described_class::CICDirectoryMissing)
          end
        end
      end
    end
  end
end
