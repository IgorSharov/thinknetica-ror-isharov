# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question_with_answers) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      let(:answer_attrs) { attributes_for(:answer) }

      it 'assigns answer\'s user' do
        post :create, params: { question_id: question, answer: answer_attrs }

        expect(assigns(:answer).user).to eq @user
      end

      it 'saves the new answer to db' do
        expect { post :create, params: { question_id: question, answer: answer_attrs } }.to \
          change(question.answers, :count).by(1)
      end

      it 'redirects to question' do
        post :create, params: { question_id: question, answer: answer_attrs }

        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      let(:invalid_answer_attrs) { attributes_for(:invalid_answer) }

      it 'doesn\'t save the new question to db' do
        expect { post :create, params: { question_id: question, answer: invalid_answer_attrs } }.not_to \
          change(Answer, :count)
      end

      it 'renders view for the new question' do
        post :create, params: { question_id: question, answer: invalid_answer_attrs }

        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    context 'done by owner' do
      let!(:answer) { create(:answer, question: question, user: @user) }

      it 'removes user\'s answer' do
        expect { delete :destroy, params: { question_id: question, id: answer } }.to \
          change(question.answers, :count).by(-1)
      end

      it 'redirects to the question' do
        delete :destroy, params: { question_id: question, id: answer }

        expect(response).to redirect_to question_path(question)
      end
    end

    context 'done by another user' do
      let!(:answer) { create(:answer, question: question, user: create(:user)) }

      it 'removes user\'s answer' do
        expect { delete :destroy, params: { question_id: question, id: answer } }.not_to \
          change(question.answers, :count)
      end

      it 'redirects to the question' do
        delete :destroy, params: { question_id: question, id: answer }

        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
