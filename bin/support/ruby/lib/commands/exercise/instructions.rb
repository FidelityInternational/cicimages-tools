require_relative '../../utils/commandline'
require_relative 'output'
require 'fileutils'
require 'yaml'

require 'page_magic'

HeadlessChrome = PageMagic::Driver.new(:headless_chrome) do |app, _options, _browser_alias_chosen|
  # Write the code necessary to initialise the driver you have chosen
  require 'selenium/webdriver'
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w[headless no-sandbox disable-gpu] }
  )

  Capybara::Selenium::Driver.new app,
                                 browser: :chrome,
                                 desired_capabilities: capabilities
end

PageMagic.drivers.register HeadlessChrome

module Exercise
  module Instructions
    include Commandline
    include Commandline::Output

    class TimeoutException < RuntimeError
    end

    class Page
      include PageMagic
    end

    def wait_until(opts = {})
      opts = { timeout_after: 5, retry_every: 0.1 }.merge(opts)
      start_time = Time.now
      until Time.now > start_time + opts[:timeout_after]
        return true if yield == true
        sleep opts[:retry_every]
      end
      raise TimeoutException, 'Action took to long'
    end

    def capture(url, filename)
      session = PageMagic.session(browser: :headless_chrome, url: url)
      session.visit(Page, url: url)
      session.browser.save_screenshot(filename)
      filename
    end

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

    def run_in_temp_directory

    end

    def write_to_file(path, content)
      directory = File.dirname(path)
      FileUtils.mkdir_p(directory)
      File.write(path, content)
      path
    end
  end
end
