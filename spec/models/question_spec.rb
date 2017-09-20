# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  context 'validate uniqueness' do
    subject { create(:question) }
    it { should validate_uniqueness_of(:title).case_insensitive }
  end

  it { should belong_to(:user) }

  it { should have_many(:answers).dependent(:destroy) }

  it { should have_db_index(:user_id) }

  describe '#best_answer' do
    let(:question) { create(:question_with_answers) }
    let!(:best_answer) { create(:answer, question: question, best_answer: true) }

    it 'gets the best answer' do
      expect(question.best_answer).to eq best_answer
    end

    it 'sets the only best answer' do
      new_best_answer = create(:answer, question: question)
      question.best_answer = { new_best_answer: new_best_answer, set_new: 'true' }

      expect(question.best_answer).to eq new_best_answer
    end
  end
end
