# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  config.include AcceptanceHelper, type: :feature
  config.include WaitForAjax, type: :feature
end
