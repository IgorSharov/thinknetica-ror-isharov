# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :user

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy, inverse_of: :attachable

  validates :title, :body, presence: true
  validates :title, uniqueness: { case_sensitive: false }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

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
