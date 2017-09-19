# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :user

  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
  validates :title, uniqueness: { case_sensitive: false }

  def best_answer
    answers.find_by(best_answer: true)
  end

  def best_answer=(id)
    answers.find(id).update(best_answer: true)
  end
end
