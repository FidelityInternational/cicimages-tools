module Commands
  module Track
    class LearningTrack
      attr_reader :name, :exercises
      def initialize(name)
        @name = name
        @exercises = []
      end

      def exercise(name:, path:)
        exercises << Exercise.new(track: self.name, name: name, path: path)
      end

      def validate
        exercises.each(&:validate)
      end

      def ==(other)
        name == other.name && exercises == other.exercises
      end
    end
  end
end
