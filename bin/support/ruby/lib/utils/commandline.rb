require 'colorize'
require 'open3'

module Commandline
  class Return
    attr_reader :stdout, :stderr, :exit_code

    def initialize(stdout:, stderr:, exit_code:)
      @stdout = normalise(stdout)
      @stderr = normalise(stderr)
      @exit_code = exit_code
    end

    def error?
      exit_code != 0
    end

    def to_s
      <<~OUTPUT
        EXIT CODE: #{exit_code}

        STDOUT:
        #{stdout}

        STDERR:
        #{stderr}
      OUTPUT
    end

    private

    def normalise(string)
      string.chomp.strip
    end
  end

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
