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

    def ==(other)
      other.to_s == to_s
    end

    private

    def normalise(string)
      string.chomp.strip
    end
  end
end
