# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  describe 'methods' do
    let(:model) { described_class }
    let(:votable) { create("#{model.to_s.underscore}_with_votes".to_sym) }
    let(:user) { create(:user) }
    let!(:vote) { create(:vote, votable: votable, user: user) }

    it 'gets summary rating' do
      expect(votable.rating).to eq 4
    end

    it 'gets rating by the user' do
      expect(votable.rating_by_user(user.id)).to eq 1
    end

    it 'gets previous vote by the user' do
      expect(votable.previous_vote_by_user(user.id)).to eq vote
    end
  end
end
