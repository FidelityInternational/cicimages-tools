require 'commands/track/command'
require 'github/api/mocks'

module Commands
  module Track
    include Github::Api::Mocks

    describe Command do
      include_context :github_api

      let(:tracks) do
        { 'tracks' => [
          { 'name' => 'ansible',
            'exercises' => [
              { 'ex1' => Dir.pwd },
              { 'ex2' => Dir.pwd }
            ] }
        ] }
      end

      let(:tracks_yaml_path) { "#{Dir.pwd}/tracks/tracks.yaml" }

      let(:track_name) { tracks['tracks'].first['name'] }
      let(:exercise) do
        exercise = tracks['tracks'].first['exercises'].first
        Exercise.new(track: "tracks/#{track_name}", name: exercise.keys.first, path: exercise.values.first)
      end

      let(:target_repo) { 'user/repo' }
      let(:api_endpoint) { "#{mirage.url}/responses" }

      before do
        allow(repos_api).to be_called.and_return(Repos::GetResponse.new(fork: true))
        write_to_file(tracks_yaml_path, tracks.to_yaml)
      end

      subject do
        described_class.new([], {}, {}, api_endpoint, tracks_yaml_path).tap do |o|
          o.options = { fork: target_repo }
        end
      end

      describe '#initialize' do
        it 'loads the tracks' do
          learning_track = LearningTrack.new(track_name)
          learning_track.exercise(name: 'ex1', path: Dir.pwd)
          learning_track.exercise(name: 'ex2', path: Dir.pwd)
          expected_tracks = { track_name => learning_track }
          expect(subject.tracks).to eq(expected_tracks)
        end

        context 'exercises invalid' do
          let(:tracks) do
            { 'tracks' => [
              { 'name' => 'ansible',
                'exercises' => [
                  { 'ex1' => 'missing path' }
                ] }
            ] }
          end

          it 'raises an error' do
            expect { subject }.to raise_error(ArgumentError)
          end
        end
      end

      describe '#start' do
        it 'creates a project board' do
          expect(projects_api).to be_called_with(name: "Learn #{track_name}")
          subject.start(track_name)
        end

        describe 'project board' do
          let(:project) { Project::CreateResponse.new }

          before do
            allow(projects_api).to be_called.and_return(project)
          end

          it 'has 3 columns' do
            expect(projects_columns_api).to be_called.times(3)

            subject.start(track_name)
          end

          it 'has a todo column' do
            expect(projects_columns_api).to be_called_with(name: 'TODO')
              .and with_uri("/projects/#{project.project_id}/columns")

            subject.start(track_name)
          end

          it 'has a in-progress column' do
            expect(projects_columns_api).to be_called_with(name: 'in-progress')
              .and with_uri("/projects/#{project.project_id}/columns")

            subject.start(track_name)
          end

          it 'has a done column' do
            expect(projects_columns_api).to be_called_with(name: 'done')
              .and with_uri("/projects/#{project.project_id}/columns")

            subject.start(track_name)
          end
        end

        context 'cards' do
          it 'creates issues for each of the exercises' do
            subject.start(track_name)

            issue1 = Issue::CreateRequest.new(data: { title: 'ex1', labels: [] }.to_json)
            issue2 = Issue::CreateRequest.new(data: { title: 'ex2', labels: [] }.to_json)
            expect(issues_api_requests).to match_array([issue1, issue2])
          end

          it 'creates cards for the issues it creates' do
            issue = Issue::CreateResponse.new
            expect(issues_api).to be_called_with(title: 'ex1').and_return(issue)
            expect(projects_cards_api).to be_called_with(content_id: issue.id)

            subject.start(track_name)
          end

          it 'creates the cards in the correct order' do
            issue1 = Issue::CreateResponse.new
            expect(issues_api).to be_called_with(title: 'ex1').and_return(issue1)
            issue2 = Issue::CreateResponse.new
            expect(issues_api).to be_called_with(title: 'ex2').and_return(issue2)

            subject.start(track_name)

            card1 = Project::Card::CreateRequest.new(data: { content_id: issue1.id, content_type: 'Issue' }.to_json)
            card2 = Project::Card::CreateRequest.new(data: { content_id: issue2.id, content_type: 'Issue' }.to_json)
            expect(projects_cards_api_requests).to eq([card2, card1])
          end

          context 'custom preamble given' do
            it 'sets it in the issue detail' do
              message = 'custom preamble'
              write_to_file("tracks/#{track_name}/#{exercise.name}.md", message)
              expectation = expect(issues_api).to be_called

              subject.start(track_name)

              expect(expectation).to have_been_called_with(exercise.detail)
            end
          end
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
            expected_msg = subject.send(:track_missing_msg, track_name)
            expect { subject.start(track_name) }.to raise_error(Thor::Error, expected_msg)
          end
        end
      end
    end
  end
end
