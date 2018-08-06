require 'octokit'
require 'netrc'
require 'yaml'
require 'uri'
require_relative 'errors'
require_relative 'helpers'

module Commands
  module Track
    class Command < Thor
      attr_reader :tracks, :tracks_yaml, :api_endpoint

      def initialize(args = [],
                     options = {},
                     config = {},
                     api_endpoint = Octokit::Default::API_ENDPOINT,
                     tracks_yaml = "#{__dir__}/../../../../../../tracks/tracks.yml")
        super(args, options, config)

        @tracks_yaml = tracks_yaml

        @api_endpoint = api_endpoint
        raise TracksFileNotFoundError.new(path: tracks_yaml) unless File.exist?(tracks_yaml)
        @tracks = load_tracks(YAML.safe_load(File.read(tracks_yaml))['tracks'])
      end

      desc 'list', 'get a list of available learning tracks'
      def list
        Dir.chdir(tracks_dir) do
          track_names = tracks.keys
          say "Available Tracks:\n #{track_names.join("\n")}"
        end
      end

      desc 'start TRACK_NAME', 'start a track'
      option :fork, desc: 'the account/repo of your fork'
      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/AbcSize
      def start(track_name)
        Dir.chdir(tracks_dir) do
          setup!(track_name)

          project_name = "Learn #{track_name}"
          project = create_project(project_name)

          todo_column = create_column(project.id, 'TODO')
          create_exercises(github_client, todo_column, track_name)

          create_column(project.id, 'in-progress')
          create_column(project.id, 'done')

          say ok "Project '#{project_name}' created: #{project.html_url}"
        end
      rescue Octokit::Unauthorized
        raise CredentialsError
      rescue Octokit::InvalidRepository
        raise InvalidForkFormatError
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/AbcSize

      no_commands do
        include Helpers
        include Commandline::Output
      end
    end
  end
end
