module Commandline
  class Command
    class Error < StandardError
      attr_reader :command_return
      def initialize command_return
        @command_return = command_return
        super
      end
    end

    include ::Commandline
    include ::Commandline::Output

    attr_reader :silent, :dir, :raise_on_error, :command
    def initialize(command, dir: nil, silent: false, raise_on_error: false)
      @command = command
      @dir = dir
      @silent = silent
      @raise_on_error = raise_on_error
    end

    alias_method(:run_proxy, :run)

    def run
      result = super(command, dir: dir, silent: silent)
      raise Error.new(result) if result.error? && raise_on_error

      result
    end
  end
end