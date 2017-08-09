# frozen_string_literal: true

class Answer < Question
  validates :title, :body, presence: true
end
