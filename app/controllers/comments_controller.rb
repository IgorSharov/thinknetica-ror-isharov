# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable

  after_action :publish_comment, only: :create

  respond_to :json

  def create
    @new_comment = @commentable.comments.build(comment_params)
    @new_comment.user = current_user
    if @new_comment.save
      render json: @new_comment.as_json(only: :body)
    else
      render json: @new_comment.errors, status: :unprocessable_entity
    end
  end

  private

  def load_commentable
    klass = [Question, Answer].detect { |c| params["#{c.name.underscore}_id"] }
    @commentable = klass.find(params["#{klass.name.underscore}_id"])
    @question = klass == Question ? @commentable : @commentable.question
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @new_comment.errors.any?
    CommentsChannel.broadcast_to(@question, @new_comment.as_json)
  end
end
