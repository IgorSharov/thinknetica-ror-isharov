# frozen_string_literal: true

require 'rails_helper'
require_relative 'concerns/votable_spec.rb'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }

  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it_behaves_like 'votable'

  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should accept_nested_attributes_for(:attachments) }

  it { should have_db_index(:question_id) }
  it { should have_db_index(:user_id) }
end
