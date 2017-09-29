# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    sign_in_user

    context 'done by parent object owner' do
      let(:question) { create(:question, user: @user) }
      let(:answer) { create(:answer, user: @user) }
      let!(:question_attachment) { create(:attachment, attachable: question) }
      let!(:answer_attachment) { create(:attachment, attachable: answer) }

      it 'removes attachments' do
        expect { delete :destroy, xhr: true, params: { id: question_attachment } }.to \
          change(question.attachments, :count).by(-1)
        expect { delete :destroy, xhr: true, params: { id: answer_attachment } }.to \
          change(answer.attachments, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, xhr: true, params: { id: question_attachment }

        expect(response).to render_template :destroy
      end
    end

    context 'done by another user' do
      let(:new_user) { create(:user) }
      let(:question) { create(:question, user: new_user) }
      let(:answer) { create(:answer, user: new_user) }
      let!(:question_attachment) { create(:attachment, attachable: question) }
      let!(:answer_attachment) { create(:attachment, attachable: answer) }

      it 'removes attachments' do
        expect { delete :destroy, xhr: true, params: { id: question_attachment } }.not_to \
          change(question.attachments, :count)
        expect { delete :destroy, xhr: true, params: { id: answer_attachment } }.not_to \
          change(answer.attachments, :count)
      end

      it 'renders destroy template' do
        delete :destroy, xhr: true, params: { id: question_attachment }

        expect(response).to render_template :destroy
      end
    end
  end
end
