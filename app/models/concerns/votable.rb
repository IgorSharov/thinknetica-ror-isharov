# frozen_string_literal: true

module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy, inverse_of: :votable
  end

  def rating
    votes.sum(:value)
  end

  def rating_by_user(user_id)
    votes.where(user_id: user_id).sum(:value)
  end

  def previous_vote_by_user(user_id)
    user_votes = votes.where(user_id: user_id)
    user_votes.last if user_votes.size.odd?
  end
end
