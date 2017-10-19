# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: :create
  before_action :load_answer, only: %i[update destroy best]

  after_action :publish_answer, only: :create

  respond_to :js

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
    respond_with @answer
  end

  def destroy
    @answer.destroy if current_user.author_of? @answer
    respond_with @answer
  end

  def update
    @answer.update(answer_params) if current_user.author_of? @answer
    respond_with @answer
  end

  def best
    question = @answer.question
    return unless current_user.author_of? question
    respond_with(question.best_answer = { new_best_answer: @answer, set_new: params[:bool] })
  end

  private

  def load_question
    @question ||= Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: %i[id file _destroy])
  end

  def publish_answer
    return if @answer.errors.any?
    AnswersChannel.broadcast_to(@question, @answer.as_json(include: :attachments))
  end
end
