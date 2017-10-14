# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable

  def create
    new_comment = @commentable.comments.build(user: current_user)
    new_comment.body = comment_params[:body]
    if new_comment.save
      render json: new_comment.to_json(only: :body)
    else
      render json: new_comment.errors, status: :unprocessable_entity
    end
  end

  private

  def load_commentable
    klass = [Question, Answer].detect { |c| params["#{c.name.underscore}_id"] }
    @commentable = klass.find(params["#{klass.name.underscore}_id"])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
