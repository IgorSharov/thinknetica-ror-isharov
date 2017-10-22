# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthAccount, type: :model do
  it { should validate_presence_of :provider }
  it { should validate_presence_of :uid }

  it { should belong_to(:user) }

  it { should have_db_index(%i[provider uid]) }
end
