# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should validate_uniqueness_of(:email).case_insensitive }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:auth_accounts).dependent(:destroy) }

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:another_question) { create(:question) }

    it 'checks for owner' do
      expect(user).to be_author_of question
    end
    it 'checks for another user' do
      expect(user).not_to be_author_of another_question
    end
  end

  describe 'rating methods' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:answer) { create(:answer) }
    let!(:vote_for_question) { create(:vote, votable: question, user: user) }
    let!(:vote_for_answer) { create(:vote, votable: answer, user: user) }

    it 'gets user\'s rating of the object' do
      expect(user.rating_of(question)).to eq 1
      expect(user.rating_of(answer)).to eq 1
    end

    it 'gets user\'s previous vote for the object' do
      expect(user.previous_vote_for(question)).to eq vote_for_question
      expect(user.previous_vote_for(answer)).to eq vote_for_answer
    end
  end
end
