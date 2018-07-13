module Commands
  module Track
    class Exercise
      attr_reader :track, :name, :path

      def initialize(track:, name:, path:)
        @track = track
        @name = name
        @path = path
      end

      def detail
        "#{preamble}[Click here](../tree/master/#{path}) to read the #{name} exercise"
      end

      def validate
        raise ArgumentError, name_error_msg unless name
        raise ArgumentError, path_error_msg unless File.exist?(path)
        true
      end

      def ==(other)
        name == other.name && path == other.path
      end

      def path_error_msg
        "Exercise: #{name} - not found at path: #{path}"
      end

      def name_error_msg
        'Name not given for exercise'
      end

      private

      def preamble
        return '' unless File.exist?(preamble_path)
        "#{File.read(preamble_path)}\n"
      end

      def preamble_path
        "#{track}/#{name}.md"
      end
    end
  end
end
