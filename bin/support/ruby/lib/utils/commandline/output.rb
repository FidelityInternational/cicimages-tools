module Commandline
  module Output
    def output
      @output ||= STDOUT
    end

    def say(msg)
      output.puts msg unless ENV['SILENT']
    end

    def ok(text)
      prefix(text, '[OK] ').green
    end

    def error(text)
      prefix(text, '[ERROR] ').red
    end

    def prefix(text, prefix)
      lines = text.lines
      message = "#{prefix}#{lines[0].strip}\n"
      lines[1..-1].each_with_index do |line, index|
        line = line.strip.chomp
        line = line.rjust(line.length + prefix.size)

        message << (index.zero? ? line : line.prepend("\n"))
      end
      message
    end
  end
end
