# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  enum vote_type: %i[up down]
  validates :vote_type, presence: true
end
