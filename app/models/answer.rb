# frozen_string_literal: true

class Answer < Question
  belongs_to :question

  validates :title, :body, presence: true
end
