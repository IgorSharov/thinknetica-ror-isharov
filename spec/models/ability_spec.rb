# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, :all }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:attachment) { create(:attachment, attachable: question) }
    let(:another_user) { create(:user) }
    let(:anothers_question) { create(:question, user: another_user) }
    let(:anothers_answer) { create(:answer, question: anothers_question, user: another_user) }
    let(:anothers_attachment) { create(:attachment, attachable: anothers_question) }

    # SHOULD
    it { should be_able_to :read, :all }
    # create
    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Vote }
    # update
    it { should be_able_to :update, question, user: user }
    it { should be_able_to :update, answer, user: user }
    # destroy
    it { should be_able_to :destroy, question, user: user }
    it { should be_able_to :destroy, answer, user: user }
    it { should be_able_to :destroy, attachment, user: user }
    # custom
    it { should be_able_to :best, answer, user: user }

    # SHOULD_NOT
    it { should_not be_able_to :manage, :all }
    # update
    it { should_not be_able_to :update, anothers_question, user: user }
    it { should_not be_able_to :update, anothers_answer, user: user }
    # destroy
    it { should_not be_able_to :destroy, anothers_question, user: user }
    it { should_not be_able_to :destroy, anothers_answer, user: user }
    it { should_not be_able_to :destroy, anothers_attachment, user: user }
    # custom
    it { should_not be_able_to :best, anothers_answer, user: user }
  end
end
