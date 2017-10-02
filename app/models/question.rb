# frozen_string_literal: true

class Question < ApplicationRecord
  include HasAttachments
  include Votable

  belongs_to :user

  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
  validates :title, uniqueness: { case_sensitive: false }

  def best_answer
    answers.find_by(best_answer: true)
  end

  def best_answer=(params_hash)
    transaction do
      best_answer&.update!(best_answer: false)
      params_hash[:new_best_answer].update!(best_answer: true) if params_hash[:set_new] == 'true'
    end
  end
end
