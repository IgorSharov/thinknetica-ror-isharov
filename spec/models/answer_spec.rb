# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it 'validates title presence' do
    expect(Answer.new(body: 'otvet')).to_not be_valid
  end

  it 'validates body presence' do
    expect(Answer.new(title: 'zagolovok')).to_not be_valid
  end
end
