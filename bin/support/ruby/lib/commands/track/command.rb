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
        @tracks = load_tracks(YAML.safe_load(File.read(tracks_yaml))['tracks'])
      end

      desc 'start TRACK_NAME', 'start a track'
      option :fork, desc: 'the account/repo of your fork'

      # rubocop:disable Metrics/MethodLength
      def start(track_name)
        Dir.chdir(tracks_dir) do
          setup!(track_name)

          project = create_project("Learn #{track_name}")

          todo_column = create_column(project.id, 'TODO')
          create_exercises(github_client, todo_column, track_name)

          create_column(project.id, 'in-progress')
          create_column(project.id, 'done')
        end
      rescue Octokit::Unauthorized
        raise CredentialsError
      rescue Octokit::InvalidRepository
        raise InvalidForkFormatError
      end
      # rubocop:enable Metrics/MethodLength

      no_commands do
        include Helpers
      end
    end
  end
end
