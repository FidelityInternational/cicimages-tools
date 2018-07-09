module Exercise
  class Output  < String
    class CIC < String
      attr_reader :container_id, :cic_start_command, :cic_connect_command, :cic_stop_command

      def initialize(string)
        @container_id = chomp(string[/cic connect (.*)/, 1])
        @cic_start_command = chomp(string[/(cic start .*)/, 1])
        @cic_connect_command = chomp(string[/(cic connect .*)/, 1])
        @cic_stop_command = chomp(string[/(cic stop .*)/, 1])
      end

      def chomp(string)
        string&.chomp
      end
    end
  end
end