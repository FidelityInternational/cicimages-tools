module Commandline
  class Command
    class Error < StandardError
      attr_reader :command_return

      def initialize(command_return)
        @command_return = command_return
        super
      end
    end

    include ::Commandline
    include ::Commandline::Output

    attr_reader :silent, :dir, :raise_on_error, :command, :env

    def initialize(command, env: {}, dir: nil, silent: false, raise_on_error: true)
      @command = command
      @dir = dir
      @silent = silent
      @raise_on_error = raise_on_error
      @env = env
    end

    alias run_proxy run

    def run
      result = super("#{env_string(env)} #{command}", dir: dir, silent: silent)
      raise Error, result if result.error? && raise_on_error

      result
    end

    private

    def env_string(env)
      ''.tap do |env_string|
        env.each do |key, value|
          env_string << "#{key}='#{value}' && "
        end
      end
    end
  end
end
