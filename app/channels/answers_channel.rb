# frozen_string_literal: true

class AnswersChannel < ApplicationCable::Channel
  def subscribed
    question = Question.find(params[:question_id])
    stream_for question
  end
end
