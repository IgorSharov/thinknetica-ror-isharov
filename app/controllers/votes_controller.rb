# frozen_string_literal: true

class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :init_record

  def create
    previous_vote_by_user = @vote.votable.previous_vote_by_user(current_user.id)
    if !previous_vote_by_user.nil? && previous_vote_by_user.vote_type != @vote.vote_type
      render json: { error: 'Incorrect vote type' }, status: :unprocessable_entity
      return
    end
    factor = previous_vote_by_user.nil? ? 1 : -1
    @vote.value = params[:value].to_i * factor
    if @vote.save
      render json: { rating: @vote.votable.rating }
    else
      render json: @vote.errors, status: :unprocessable_entity
    end
  end

  private

  def init_record
    @vote = Vote.new do |v|
      v.votable_type = params[:votable_type]
      v.votable_id = params[:votable_id]
      v.user = current_user
      v.vote_type = params[:vote_type]
    end
  end
end
