# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]
  after_action :publish_question, only: :create

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      flash[:notice] = 'Question successfully created.'
      redirect_to root_path
    else
      flash.now[:alert] = 'An error occurred while creating the question!'
      render :new
    end
  end

  def show
    @answer = Answer.new
    @best_answer = @question.answers.find_by best_answer: true
  end

  def destroy
    if current_user.author_of? @question
      if @question.destroy
        flash[:notice] = 'Question successfully deleted.'
      else
        flash[:alert] = 'An error occurred while deleting the question!'
      end
    end
    redirect_to root_path
  end

  def update
    return unless current_user.author_of? @question
    if @question.update(question_params)
      flash[:notice] = 'Question successfully updated.'
    else
      flash[:alert] = 'An error occurred while updating the question!'
    end
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: %i[id file _destroy])
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question_for_index',
        locals: { question: @question }
      )
    )
  end
end
