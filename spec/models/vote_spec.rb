# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:votable) }
  it { should belong_to(:user) }

  it { should validate_presence_of :vote_type }
  it { should define_enum_for(:vote_type).with(%i[up down]) }

  it { should have_db_index(%i[votable_type votable_id]) }
  it { should have_db_index(:user_id) }
end
