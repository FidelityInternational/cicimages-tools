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
          print line unless silent || ENV['SILENT']
        end
      end
    end
  end

  def run(command, dir: nil, silent: true)
    options = {}
    options[:chdir] = dir if dir
    stdin, stdout, stderr, thread = Open3.popen3("bash -c '#{command}'", options)
    stderr_output = capture_output(stderr, silent: silent)
    stdout_output = capture_output(stdout, silent: silent)

    wait_for_thread(thread)

    [stdin, stdout, stderr].each(&:close)

    Return.new(stdout: stdout_output.string, stderr: stderr_output.string, exit_code: thread.value.exitstatus)
  end

  # TODO: - think about how to bring the run and execute methods together or give more differentiating names
  def execute(*commands, fail_message:, pass_message:)
    fail = false
    commands.each do |command|
      result = run command
      say result.stdout
      next unless result.error?
      fail = true
      say result.stderr
      say error fail_message
    end
    say ok pass_message unless fail
  end

  private

  def wait_for_thread(thread)
    sleep 1 while thread.alive?
  end
end
