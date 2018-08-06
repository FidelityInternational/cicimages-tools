module Commands
  module Track
    module Helpers
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

      def enable_issues
        github_client.edit_repository(fork, has_issues: true)
      end

      def fork
        options[:fork]
      end

      def github_client
        @github_client ||= begin
          options = { netrc: true, api_endpoint: api_endpoint }
          Octokit::Client.new(options).tap do |client|
            raise NetrcMissingError unless File.exist?(client.netrc_file)
            host = URI(client.api_endpoint).host
            raise MissingCredentialsError, host unless Netrc.read(client.netrc_file)[host]
          end
        end
      end

      def load_tracks(hash)
        {}.tap do |tracks|
          hash.each do |track|
            tracks[build_track(track).name] = build_track(track)
          end
        end
      end

      def track_exists?(track_name)
        tracks.key?(track_name)
      end

      def track_names
        tracks.keys
      end

      def tracks_dir
        File.dirname(File.expand_path(tracks_yaml))
      end

      def setup!(track_name)
        raise TrackNotFoundError.new(track_name: track_name, track_names: track_names) unless track_exists?(track_name)

        repo = github_client.repo(fork)

        raise RepoIsNotForkError, fork unless repo['fork'] == true
        enable_issues
      end
    end
  end
end
