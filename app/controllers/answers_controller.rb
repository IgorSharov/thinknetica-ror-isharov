# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: %i[create destroy]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    if @answer.save
      flash[:notice] = 'Answer successfully created.'
    else
      flash[:alert] = 'An error occurred while creating the answer!'
    end
    flash[:validation_errors] = @answer.errors.messages
    redirect_to question_path(@question)
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy if @answer.user.id? current_user.id
    redirect_to question_path(@question)
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
