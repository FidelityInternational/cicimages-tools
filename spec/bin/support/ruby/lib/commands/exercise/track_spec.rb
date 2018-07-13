require 'commands/track'
require 'github/api/mocks'

module Commands
  include Github::Api::Mocks

  describe Track do
    include_context :github_api

    let(:tracks_yaml) do
      "#{Dir.pwd}/tracks.yaml".tap do |path|
        tracks = { 'tracks' => [
          { 'name' => 'ansible',
            'exercises' => [
              { 'running_ansible' => 'IaC/ansible/running_ansible' },
              { 'writing_playbooks' => 'IaC/ansible/writing_playbooks' }
            ] }
        ] }

        File.write(path, tracks.to_yaml)
      end
    end

    let(:track_name) { YAML.safe_load(File.read(tracks_yaml))['tracks'].first['name'] }
    let(:target_repo) { 'user/repo' }
    let(:api_endpoint) { 'http://localhost:7001/responses' }

    before do
      allow(repos_api).to be_called.and_return(Repos::GetResponse.new(fork: true))
    end

    subject do
      described_class.new([], {}, {}, api_endpoint, tracks_yaml).tap do |o|
        o.options = { fork: target_repo }
      end
    end

    describe '#start' do
      it 'creates a project board' do
        expect(project_api).to be_called_with(name: "Learn #{track_name}")
        subject.start(track_name)
      end

      describe 'project board' do
        let(:project) { Project::CreateResponse.new }

        before do
          allow(project_api).to be_called_with(name: "Learn #{track_name}").and_return(project)
        end

        it 'has a todo column' do
          expect(project_column_api).to be_called_with(name: 'TODO')
          subject.start(track_name)
        end

        it 'has a in-progress column' do
          expect(project_column_api).to be_called_with(name: 'in-progress')
          subject.start(track_name)
        end

        it 'has a done column' do
          expect(project_column_api).to be_called_with(name: 'done')
            .and with_uri("/projects/#{project.project_id}/columns")
          subject.start(track_name)
        end
      end

      it 'creates cards for the given tracks' do
        issue = Issue::CreateResponse.new
        expect(issue_api).to be_called_with(title: 'running_ansible').and_return(issue)
        expect(project_card_api).to be_called_with(content_id: issue.id)

        subject.start(track_name)
      end

      context '--fork' do
        context 'is not a fork' do
          it 'throws an error' do
            repo = Repos::GetResponse.new(fork: false)
            expect(repos_api).to be_called.and_return(repo)
            expect { subject.start(track_name) }.to raise_error(Thor::Error, subject.send(:repo_error_msg))
          end
        end
      end

      context 'track does exist' do
        let(:track_name) { 'missing_track' }
        it 'raises an error' do
          expect { subject.start(track_name) }.to raise_error(Thor::Error, subject.send(:track_missing_msg, track_name))
        end
      end
    end
  end
end
