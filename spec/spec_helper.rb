require 'capybara/rspec'
require 'yaml'
require 'capybara'
require 'selenium-webdriver'
require 'site_prism'
require 'faker'
require 'rspec/retry'
require 'rspec_junit_formatter'
require 'capybara-screenshot/rspec'
require 'curb'
require_relative '../spec/pages/landing_page'

require './helpers/app'
require './helpers/users'

RSpec.configure do |config|
  config.verbose_retry = true
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

Capybara.configure do |config|
  config.run_server = false
  config.ignore_hidden_elements = false
  config.default_driver = :selenium
  config.default_max_wait_time = 30
  config::Screenshot.autosave_on_failure = true
  config.save_and_open_page_path = 'test_reports/'
  config.app_host = ENV['APP_HOST']
end

QAEVAL_API_URL = ENV['APP_HOST']

if ENV['GRID_URL']
  Capybara.register_driver :selenium do |app|
  #   Capybara::Selenium::Driver.new(app,
  #                                  browser: :remote,
  #                                  url: ENV['GRID_URL'],
  #                                  desired_capabilities: :firefox)
  end
else
  if ENV['browser']
    Capybara.register_driver :selenium do |app|
      case
        when ENV['browser'] == 'chrome'
          Capybara::Selenium::Driver.new(app, :browser => :chrome)
        when ENV['browser'] == 'safari'
          Capybara::Selenium::Driver.new(app, :browser => :safari)
        else
          Capybara::Selenium::Driver.new(app, :browser => :firefox)
      end
    end
  end
end
