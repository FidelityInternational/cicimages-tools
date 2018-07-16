require 'octokit'
require 'netrc'
require 'yaml'
module Commands
  module Track
    class Command < Thor
      attr_reader :github_client, :tracks, :tracks_yaml

      def initialize(args = [],
                     options = {},
                     config = {},
                     api_endpoint = nil,
                     tracks_yaml = "#{__dir__}/../../../../../../tracks/tracks.yml")
        super(args, options, config)

        @tracks_yaml = tracks_yaml

        @github_client ||= begin
          client_options = { netrc: true }
          client_options[:api_endpoint] = api_endpoint if api_endpoint
          Octokit::Client.new(client_options)
        end
        @tracks = load_tracks(YAML.safe_load(File.read(tracks_yaml))['tracks'])
      end

      desc 'start TRACK_NAME', 'start a track'
      option :fork, desc: 'the account/repo of your fork'

      def start(track_name)
        Dir.chdir(tracks_dir) do
          validate!(track_name)

          project = create_project("Learn #{track_name}")

          todo_column = create_column(project.id, 'TODO')
          create_exercises(github_client, todo_column, track_name)

          create_column(project.id, 'in-progress')
          create_column(project.id, 'done')
        end
      end

      # rubocop:disable Metrics/BlockLength
      no_commands do
        private

        def build_track(track)
          LearningTrack.new(track['name']).tap do |learning_track|
            track['exercises'].each do |exercise|
              name, path = exercise.flatten.to_a
              learning_track.exercise(name: name, path: path)
            end

            learning_track.validate
          end
        end

        def create_column(project_id, name)
          github_client.create_project_column(project_id, name, default_projects_options)
        end

        def create_exercises(client, todo_column, track_name)
          tracks[track_name].exercises.reverse.each do |exercise|
            issue = client.create_issue(fork, exercise.name, exercise.detail, labels: '')

            options = default_projects_options.merge(content_id: issue.id, content_type: 'Issue')
            client.create_project_card(todo_column.id, options)
          end
        end

        def create_project(board_name)
          github_client.create_project(fork, board_name, default_projects_options)
        end

        def default_projects_options
          { accept: 'application/vnd.github.inertia-preview+json' }
        end

        def fork
          options[:fork]
        end

        def load_tracks(hash)
          {}.tap do |tracks|
            hash.each do |track|
              tracks[build_track(track).name] = build_track(track)
            end
          end
        end

        def repo_error_msg
          "#{fork} is not a fork. Please for the CIC repo and try again"
        end

        def track_exists?(track_name)
          tracks.key?(track_name)
        end

        def track_names
          tracks.keys
        end

        def track_missing_msg(track_name)
          "Track #{track_name} not found.\nPlease choose from:#{track_names.join("\n")}"
        end

        def tracks_dir
          File.dirname(File.expand_path(tracks_yaml))
        end

        def validate!(track_name)
          raise Thor::Error, track_missing_msg(track_name) unless track_exists?(track_name)

          repo = github_client.repo(fork)

          raise Thor::Error, repo_error_msg unless repo['fork'] == true
        end
      end
      # rubocop:enable Metrics/BlockLength
    end
  end
end
