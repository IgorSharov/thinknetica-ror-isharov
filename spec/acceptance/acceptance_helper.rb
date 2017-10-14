# frozen_string_literal: true

require 'rails_helper'

Capybara.default_max_wait_time = 10
Capybara.server = :puma

RSpec.configure do |config|
  config.include AcceptanceHelper, type: :feature
  config.include WaitForAjax, type: :feature
end
