module Exercise
  class Output < String
    class Pytest < String
      attr_reader :summary

      def initialize(string)
        @summary = chomp(string[/(=+.*100%\])/m, 1])
      end

      def chomp(string)
        string&.chomp
      end
    end
  end
end
