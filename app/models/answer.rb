# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question

  validates :title, :body, :question_id, presence: true
  validates :title, uniqueness: { case_sensitive: false }
  validates :question_id, numericality: true
end