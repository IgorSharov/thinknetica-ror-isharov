# frozen_string_literal: true

require 'rails_helper'
require 'capybara/email/rspec'

RSpec.configure do |config|
  config.include AcceptanceHelper, type: :feature
  config.include WaitForAjax, type: :feature
  config.include OmniauthMacros, type: :feature
end

# On remote machine run:
# java -jar selenium-server-standalone-3.14.0.jar -port 3000

Capybara.server = :puma
Capybara.server_host = '192.168.56.2'
Capybara.server_port = 3002
Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"
Capybara.default_max_wait_time = 15
browser = :firefox # :firefox || :chrome
Capybara.register_driver :"selenium_remote_#{browser}" do |app|
  Capybara::Selenium::Driver.new(app,
                                 browser: :remote,
                                 url: 'http://192.168.56.1:3000/wd/hub',
                                 desired_capabilities: browser)
end
Capybara.javascript_driver = :"selenium_remote_#{browser}"

OmniAuth.config.test_mode = true
