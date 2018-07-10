module Exercise
  class Output < String
    class Pytest < String
      attr_reader :summary

      def initialize(string)
        @summary = chomp(string[/(=+[\w\s]+=+$.*?)^=+[\w\s]+=+/m, 1])
      end

      def chomp(string)
        string&.chomp
      end
    end
  end
end
