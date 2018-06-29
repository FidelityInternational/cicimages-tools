require 'colorize'
require 'open3'
require_relative 'commandline/return'
module Commandline
  def run(command)
    stdout, stderr, status = Open3.capture3("bash -c '#{command}'")
    Return.new(stdout: stdout, stderr: stderr, exit_code: status.exitstatus)
  end

  module Output
    def output
      @output ||= STDOUT
    end

    def say(msg)
      output.puts msg
    end

    def ok(text)
      lines = text.lines
      prefix = '[OK] '
      message = "#{prefix}#{lines[0].strip}\n"
      lines[1..-1].each_with_index do |line, index|
        line = line.strip
        line = line.rjust(line.length + prefix.size)
        message << line.prepend("\n") unless index.zero?
      end
      message.green
    end

    def error(text)
      "[ERROR] #{text}".red
    end
  end
end
