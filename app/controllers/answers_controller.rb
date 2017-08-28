# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: %i[create destroy]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    if @answer.save
      flash[:notice] = 'Answer successfully created.'
      redirect_to question_path(@question)
    else
      flash.now[:alert] = 'An error occurred while creating the answer!'
      render 'questions/show'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.author_of? @answer
      if @answer.destroy
        flash[:notice] = 'Answer successfully deleted.'
      else
        flash[:alert] = 'An error occurred while deleting the answer!'
      end
    end
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
