require_relative '../../utils/commandline'
require_relative 'output'
require 'fileutils'
require 'yaml'
module Exercise
  module Instructions
    include Commandline
    include Commandline::Output

    def cd(dir)
      Dir.chdir(dir)
      "cd #{dir}"
    end

    def path(path)
      raise "#{path} does not exist" unless File.exist?(path)
      path
    end

    def test_command(command, fail_on_error: true)
      say "running: #{command}" unless quiet?
      result = @result = run(command)
      if result.error? && fail_on_error
        say error("failed to run: #{command}\n\n#{result}")
      elsif quiet?
        output.print '.'.green
      else
        say ok("Successfully ran: #{command}")
      end

      result
    end

    def after_all_commands
      @after_all_commands ||= []
    end

    def after_all(command)
      after_all_commands << command
      command
    end

    def command_output(command)
      command command
      last_command_output
    end

    def command(command, fail_on_error: true)
      result = test_command(command, fail_on_error: fail_on_error)
      raise CommandError if result.error? && fail_on_error
      command
    end

    def last_command_output
      Output.new(@result.stdout)
    end

    def write_to_file(path, content)
      directory = File.dirname(path)
      FileUtils.mkdir_p(directory)
      File.write(path, content)
      path
    end
  end
end
