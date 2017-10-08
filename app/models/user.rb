# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :answers, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :votes, dependent: :destroy

  def author_of?(object)
    object.user_id == id
  end

  def rating_of(votable)
    votes.where(votable_type: votable.class.name, votable_id: votable.id).sum(:value)
  end

  def previous_vote_for(votable)
    user_votes = votes.where(votable_type: votable.class.name, votable_id: votable.id)
    user_votes.last if user_votes.size.odd?
  end
end
