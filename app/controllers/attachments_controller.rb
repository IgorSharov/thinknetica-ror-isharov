# frozen_string_literal: true

class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def destroy
    @attachment = Attachment.find(params[:id])
    return unless current_user.author_of? @attachment.attachable
    if @attachment.destroy
      flash[:notice] = 'Attachment successfully deleted.'
    else
      flash[:alert] = 'An error occurred while deleting the attachment!'
    end
  end
end
