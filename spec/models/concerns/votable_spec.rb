# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  describe 'methods' do
    let(:model) { described_class }
    let(:votable) { create("#{model.to_s.underscore}_with_votes".to_sym) }

    it 'gets summary rating' do
      expect(votable.rating).to eq 3
    end
  end
end
