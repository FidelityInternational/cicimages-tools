module Exercise
  class Output  < String
    class Ansible < String

      attr_reader :tasks, :play, :play_recap

      def initialize(string)
        super
        @tasks = string.scan(/(TASK .*\*$\n.*)/).flatten
        @play = string.scan(/(PLAY \[.*\*$)/).flatten.first
        @play_recap = string.scan(/(PLAY RECAP.*\*$\n.*)/).flatten.first
      end
    end
  end
end