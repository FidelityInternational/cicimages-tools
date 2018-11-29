require 'colorize'
require 'open3'
require 'io/wait'

require_relative 'commandline/return'
require_relative 'commandline/output'

module Commandline
  include Output

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

  private
  def capture_output(io, silent:)
    StringIO.new.tap do |store|
      Thread.new do
        while (line = io.getc)
          store.write(line.dup)
          output.write line unless silent || ENV['SILENT']
        end
      end
    end
  end

  def wait_for_thread(thread)
    sleep 1 while thread.alive?
  end
end

require_relative 'commandline/command'


