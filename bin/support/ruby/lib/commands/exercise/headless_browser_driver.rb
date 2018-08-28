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