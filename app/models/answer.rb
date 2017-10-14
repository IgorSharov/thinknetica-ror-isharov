# frozen_string_literal: true

class Answer < ApplicationRecord
  include Attachable
  include Commentable
  include Votable

  belongs_to :user
  belongs_to :question

  validates :body, presence: true
end
