# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_numericality_of(:question_id) }

  it { should belong_to(:question) }

  it { should have_db_index(:question_id) }
end
