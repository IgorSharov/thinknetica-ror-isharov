# frozen_string_literal: true

module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy, inverse_of: :votable
  end

  def rating
    votes.sum(:value)
  end

  def vote(params, current_user)
    vote = votes.build
    if current_user.author_of? self
      vote.errors.add(:user, 'cannot vote for own objects')
      return vote
    else
      vote.user_id = current_user.id
    end
    previous_vote_by_user = current_user.previous_vote_for self
    factor = previous_vote_by_user.nil? ? 1 : -1
    vote.value = params[:value].to_i * factor
    vote.vote_type = params[:vote_type]
    unless previous_vote_by_user.nil?
      vote.errors.add(:vote_type, 'Incorrect vote type') if previous_vote_by_user.vote_type != vote.vote_type
      vote.errors.add(:value, 'Incorrect value') if previous_vote_by_user.value == vote.value
    end
    vote
  end
end
