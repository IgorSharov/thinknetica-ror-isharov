# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :user

  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
  validates :title, uniqueness: { case_sensitive: false }
end
