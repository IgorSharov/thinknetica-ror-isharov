# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: %i[update destroy]
  before_action :load_question, only: %i[create update destroy best_answer]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    if @answer.save
      flash[:notice] = 'Answer successfully created.'
    else
      flash.now[:alert] = 'An error occurred while creating the answer!'
    end
  end

  def destroy
    return unless current_user.author_of? @answer
    if @answer.destroy
      flash[:notice] = 'Answer successfully deleted.'
    else
      flash[:alert] = 'An error occurred while deleting the answer!'
    end
  end

  def update
    return unless current_user.author_of? @answer
    if @answer.update(answer_params)
      flash[:notice] = 'Answer successfully updated.'
    else
      flash[:alert] = 'An error occurred while updating the answer!'
    end
  end

  def best_answer
    return unless current_user.author_of? @question
    params.require(:bool)
    set_new_best_answer = params[:bool] == 'true'
    old_best_answer = @question.answers.find_by(best_answer: true)
    if old_best_answer
      old_best_answer.best_answer = false
      old_best_answer.save
    end
    @new_best_answer = @question.answers.find(params[:id])
    flash[:notice] = 'Answer successfully updated.'
    return unless set_new_best_answer
    flash[:alert] = 'An error occurred while updating the answer!' unless @new_best_answer.update(best_answer: true)
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
