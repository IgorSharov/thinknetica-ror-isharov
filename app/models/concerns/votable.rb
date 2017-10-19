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
    vote = votes.build(user: current_user)
    previous_vote_by_user = current_user.previous_vote_for self
    factor = previous_vote_by_user.nil? ? 1 : -1
    vote.value = params[:value].to_i * factor
    vote.vote_type = params[:vote_type]
    vote.previous_vote_by_user = previous_vote_by_user unless previous_vote_by_user.nil?
    vote
  end
end
