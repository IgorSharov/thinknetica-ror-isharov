# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  enum vote_type: %i[up down]
  validates :vote_type, presence: true

  validate :self_voting,
           :previous_vote

  attr_accessor :previous_vote_by_user

  private

  def self_voting
    errors.add(:user, 'Cannot vote for own objects') if user&.author_of? votable
  end

  def previous_vote
    return if previous_vote_by_user.nil?
    errors.add(:vote_type, 'Incorrect vote type') if previous_vote_by_user.vote_type != vote_type
    errors.add(:value, 'Incorrect value') if previous_vote_by_user.value == value
  end
end
