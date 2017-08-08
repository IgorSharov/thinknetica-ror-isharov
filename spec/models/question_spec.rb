# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it 'validates title presence' do
    expect(Question.new(body: 'vopros')).to_not be_valid
  end

  it 'validates body presence' do
    expect(Question.new(title: 'zagolovok')).to_not be_valid
  end
end
