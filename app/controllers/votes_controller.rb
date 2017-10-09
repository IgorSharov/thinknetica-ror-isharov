# frozen_string_literal: true

class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_votable

  def create
    new_vote = @votable.vote(params, current_user)
    if new_vote.errors.any?
      render json: new_vote.errors, status: :unprocessable_entity
    else
      new_vote.save
      render json: { rating: @votable.rating }
    end
  end

  private

  def load_votable
    klass = [Question, Answer].detect { |c| params["#{c.name.underscore}_id"] }
    @votable = klass.find(params["#{klass.name.underscore}_id"])
  end
end
