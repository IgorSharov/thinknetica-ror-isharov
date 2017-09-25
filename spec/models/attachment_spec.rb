# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Attachment, type: :model do
  it { should belong_to(:attachable) }

  context 'when initialized #file' do
    subject { Attachment.new.file }
    it { should be_a(FileUploader) }
  end

  it { should have_db_index(%i[attachable_type attachable_id]) }
end
