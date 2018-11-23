module Commands
  module Track
    class NetrcMissingError < Thor::Error
      def initialize
        super '.netrc file missing. Add a .netrc file to your home folder with your github credentials in it'
      end
    end

    class InvalidForkFormatError < Thor::Error
      def initialize
        super 'Fork option container invalid characters. Check you have typed it correctly.'
      end
    end

    class MissingCredentialsError < Thor::Error
      def initialize(host)
        super ".netrc does not container credentials for #{host}"
      end

      def ==(other)
        to_s == other.to_s
      end
    end

    class CredentialsError < Thor::Error
      def initialize
        super "Authorisation failed. Check the fork you're targeting and the credentials in your .netrc"
      end
    end

    class RepoIsNotForkError < Thor::Error
      def initialize(fork)
        super "#{fork} is not a fork. Please for the CIC repo and try again"
      end

      def ==(other)
        to_s == other.to_s
      end
    end

    class TrackNotFoundError < Thor::Error
      def initialize(track_name:, track_names:)
        super "Track #{track_name} not found.\nPlease choose from:#{track_names.join("\n")}"
      end

      def ==(other)
        to_s == other.to_s
      end
    end

    class TracksFileNotFoundError < Thor::Error
      def initialize(path:)
        super "Tracks file not found at: #{path}"
      end
    end
  end
end
