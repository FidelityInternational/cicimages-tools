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
      def start(track_name)
        Dir.chdir(tracks_dir) do
          setup!(track_name)

          project = create_project("Learn #{track_name}")

          columns = create_columns(project.id, %w[TODO in-progress done])

          create_exercises(columns['TODO'], track_name)

          say ok "Project '#{project.name}' created: #{project.html_url}"
        end
      rescue StandardError => e
        raise error_for(e)
      end

      no_commands do
        include Helpers
        include Commandline::Output

        def error_for(error)
          mapped_errors = { Octokit::Unauthorized => CredentialsError,
                            Octokit::InvalidRepository => InvalidForkFormatError }

          mapped_errors[error.class] || error
        end
      end
    end
  end
end
