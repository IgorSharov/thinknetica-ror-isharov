# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]
  before_action :build_answer_and_comment, only: :show
  before_action :pass_params_to_js, only: :show

  after_action :publish_question, only: :create

  respond_to :js, only: :update

  authorize_resource

  def index
    respond_with(@questions = Question.all)
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with @question = current_user.questions.create(question_params), location: -> { root_path }
  end

  def show
    respond_with @question
  end

  def destroy
    @question.destroy if current_user.author_of? @question
    respond_with @question, location: -> { root_path }
  end

  def update
    @question.update(question_params) if current_user.author_of? @question
    respond_with @question
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: %i[id file _destroy])
  end

  def load_question
    @question ||= Question.find(params[:id])
  end

  def build_answer_and_comment
    @answer = Answer.new
    @comment = Comment.new
  end

  def pass_params_to_js
    gon.question_id = @question.id
    gon.question_user_id = @question.user.id
    gon.current_user_id = current_user&.id
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
