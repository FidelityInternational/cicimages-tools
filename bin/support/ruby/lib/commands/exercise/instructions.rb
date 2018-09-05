require_relative '../../utils/commandline'
require_relative 'output'
require 'fileutils'
require 'yaml'
require_relative 'headless_browser_driver'

module Exercise
  # module Instructions - Helper methods to be used within templates
  module Instructions
    include Commandline
    include Commandline::Output

    # class TimeoutError - error raised when something has taken to long
    class TimeoutError < RuntimeError
    end

    # Runs the given command after the current template has been rendered. This is useful for running commands to clean
    # clean up. E.g. stopping a server that was previously started.
    # @example
    #   In ERB template:
    #   <%= after_rendering_run('cic down') %>
    # @param [String] command the command to be run.
    # @return [String] the command input parameter is returned so that it can be displayed within a template
    def after_rendering_run(command)
      after_rendering_commands << command
      command
    end

    # Captures and saves screenshots.
    # Useful for adding images to your templates.
    # @example
    #   In ERB template:
    #   ![Screenshot](<%= capture('http://the.url.com', 'filename.png') %>)
    # @param [String] url the url to take a screenshot of.
    # @param [String] filename the filename to save the screenshot to.
    # @return [String] The filename of the saved screenshot
    def capture(url, filename)
      page_class = Class.new { include PageMagic }
      session = PageMagic.session(browser: :headless_chrome, url: url)
      session.visit(page_class, url: url)
      session.browser.save_screenshot(filename)
      filename
    end

    # Change directory
    # Change directory so that subsequent commands are executed in the correct context
    # @example
    #   In ERB template:
    #   <%= cd('path') %>
    # @param [String] path the path to move to
    # @return [String] the path moved to
    def cd(path)
      Dir.chdir(path)
      "cd #{path}"
    end

    # Execute a command
    # @example
    #   In ERB template:
    #   <%= command('mkdir my_directory') %>
    # @param [String] command the command to execute
    # @param [Boolean] fail_on_error whether to raise an error if the command fails to execute
    # @return [String] the command that was executed
    # @raise [CommandError] if command errors and if fail_on_error is set to to true
    def command(command, fail_on_error: true)
      result = test_command(command, fail_on_error: fail_on_error)
      raise CommandError if result.error? && fail_on_error
      command
    end

    # get the output of a command
    # @example
    #   In ERB template:
    #   <%= command_output('mkdir my_directory') %>
    # @param [String] command the command to execute.
    # @return [String] the output of the command executed.
    def command_output(command)
      command command
      last_command_output
    end

    # get the output of the last command that was run.
    # @example
    #   In ERB template:
    #   <%= last_command_output %>
    # @return [String] the output of the last command.
    def last_command_output
      Output.new(@result.stdout)
    end

    # Validate a path
    # @example
    #   In ERB template:
    #   <%= path('the/path') %>
    # @return [String] the output of the last command.
    # @raise [RuntimeError] if given path does not exist
    def path(path)
      raise "#{path} does not exist" unless File.exist?(path)
      path
    end

    # Wait until the given block evaluates to true
    # @example
    #   In ERB template:
    #   <%
    #     wait_until do
    #       # code
    #     end
    #   %>
    # @param timeout_after [Fixnum] the number of seconds to wait before timing out.
    # @param retry_every [Float] the number of seconds to wait before re-evaluating the given block again
    # @raise [TimeoutError] if given block does not return true within the allowed time.
    def wait_until(timeout_after: 5, retry_every: 0.1)
      start_time = Time.now
      until Time.now > start_time + timeout_after
        return true if yield == true
        sleep retry_every
      end
      raise TimeoutError, 'Action took to long'
    end

    # Write the given content to file
    # @example
    #   In ERB template:
    #   <%
    #     write_to_file('path/file.txt', 'content')
    #   %>
    # @param [String] path the path to write the file to.
    # @param [Float] content the content to write to file
    # @return [String] the path that the file was written to.
    def write_to_file(path, content)
      directory = File.dirname(path)
      FileUtils.mkdir_p(directory)
      File.write(path, content)
      path
    end

    protected

    def after_rendering_commands
      @after_rendering_commands ||= []
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
  end
end
