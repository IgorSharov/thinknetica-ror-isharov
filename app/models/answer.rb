# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question

  validates :title, :body, presence: true
  validates :title, uniqueness: { case_sensitive: false }
end
