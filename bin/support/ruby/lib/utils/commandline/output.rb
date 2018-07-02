module Commandline
  module Output
    def output
      @output ||= STDOUT
    end

    def say(msg)
      output.puts msg
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

        if index.zero?
          message << line
        else
          message << line.prepend("\n")
        end
      end
      message
    end
  end
end