# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:votable) }
  it { should belong_to(:user) }

  it { should have_db_index(%i[votable_type votable_id]) }
  it { should have_db_index(:user_id) }
end
