# frozen_string_literal: true

FactoryBot.define do
  factory :attachment do
    file { File.new(Rails.root.join('spec', 'fixtures', 'files', 'test_file.txt')) }
  end
end
