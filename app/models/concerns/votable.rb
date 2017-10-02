# frozen_string_literal: true

module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable, dependent: :destroy, inverse_of: :votable
  end

  def rating
    votes.sum(:value)
  end
end
