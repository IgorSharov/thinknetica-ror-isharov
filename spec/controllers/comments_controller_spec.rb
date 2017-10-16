# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'POST #create' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer) }
    let(:comment_attrs) { attributes_for(:comment) }

    context 'authenticated user' do
      sign_in_user

      it 'comments questions and answer' do
        commentable = question
        expect { post :create, params: { question_id: commentable.id, comment: comment_attrs, format: :json } }.to change(commentable.comments, :count).by(1)

        commentable = answer
        expect { post :create, params: { answer_id: commentable.id, comment: comment_attrs, format: :json } }.to change(commentable.comments, :count).by(1)
      end

      it 'renders json' do
        commentable = question
        post :create, params: { question_id: commentable.id, comment: comment_attrs, format: :json }
        expect(response).to have_http_status(:success)
        expect(response.body).to eq comment_attrs.to_json

        commentable = answer
        post :create, params: { answer_id: commentable.id, comment: comment_attrs, format: :json }
        expect(response).to have_http_status(:success)
        expect(response.body).to eq comment_attrs.to_json
      end
    end

    context 'non authenticated user' do
      it 'comments questions and answer' do
        commentable = question
        expect { post :create, params: { question_id: commentable.id, comment: comment_attrs, format: :json } }.not_to change(commentable.comments, :count)

        commentable = answer
        expect { post :create, params: { answer_id: commentable.id, comment: comment_attrs, format: :json } }.not_to change(commentable.comments, :count)
      end

      it 'renders json' do
        commentable = question
        post :create, params: { question_id: commentable.id, comment: comment_attrs, format: :json }
        expect(response).to have_http_status(:unauthorized)

        commentable = answer
        post :create, params: { answer_id: commentable.id, comment: comment_attrs, format: :json }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
