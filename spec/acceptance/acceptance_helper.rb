# frozen_string_literal: true

require 'rails_helper'
require 'capybara/email/rspec'

RSpec.configure do |config|
  config.include AcceptanceHelper, type: :feature
  config.include WaitForAjax, type: :feature
  config.include OmniauthMacros, type: :feature
end

Capybara.default_max_wait_time = 10
Capybara.server = :puma

OmniAuth.config.test_mode = true
