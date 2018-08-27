# frozen_string_literal: true

RSpec.configure do |config|
  config.after(:suite) do
    FileUtils.rm_rf(Dir["#{Rails.root}/spec/support/uploads"]) if Rails.env.test?
  end
end
