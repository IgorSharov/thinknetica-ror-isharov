# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show destroy]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      flash[:notice] = 'Question successfully created.'
      redirect_to root_path
    else
      flash[:alert] = 'An error occurred while creating the question!'
      flash[:validation_errors] = @question.errors.messages
      redirect_to new_question_path
    end
  end

  def show
    @answer = Answer.new
  end

  def destroy
    if @question.user.id? current_user.id
      if @question.destroy
        flash[:notice] = 'Question successfully deleted.'
      else
        flash[:alert] = 'An error occurred while deleting the question!'
      end
    end
    redirect_to root_path
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
