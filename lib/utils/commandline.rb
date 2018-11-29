require 'colorize'
require 'open3'
require 'io/wait'
require_relative 'commandline/return'
require_relative 'commandline/output'

module Commandline



  def capture_output(io, silent: true)
    StringIO.new.tap do |store|
      Thread.new do
        while (line = io.getc)
          store.write(line.dup)
          output.write line unless silent || ENV['SILENT']
        end
      end
    end
  end

  def run(command, dir: nil, silent: true)
    options = {}
    options[:chdir] = dir if dir
    stdin, stdout, stderr, thread = Open3.popen3("bash -lc '#{command}'", options)
    stderr_output = capture_output(stderr, silent: silent)
    stdout_output = capture_output(stdout, silent: silent)

    wait_for_thread(thread)

    [stdin, stdout, stderr].each(&:close)

    Return.new(stdout: stdout_output.string, stderr: stderr_output.string, exit_code: thread.value.exitstatus)
  end


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

  private

  def wait_for_thread(thread)
    sleep 1 while thread.alive?
  end
end
