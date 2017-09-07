# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let!(:question) { create(:question_with_answers) }

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:answer_attrs) { attributes_for(:answer) }

      it 'assigns answer\'s user' do
        post :create, params: { question_id: question, answer: answer_attrs, format: :js }

        expect(assigns(:answer).user).to eq @user
      end

      it 'saves the new answer to db' do
        expect { post :create, params: { question_id: question, answer: answer_attrs, format: :js } }.to \
          change(question.answers, :count).by(1)
      end

      it 'renders answer create' do
        post :create, params: { question_id: question, answer: answer_attrs, format: :js }

        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      let(:invalid_answer_attrs) { attributes_for(:invalid_answer) }

      it 'doesn\'t save the new question to db' do
        expect { post :create, params: { question_id: question, answer: invalid_answer_attrs, format: :js } }.not_to \
          change(Answer, :count)
      end

      it 'renders answer create' do
        post :create, params: { question_id: question, answer: invalid_answer_attrs, format: :js }

        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
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

      it 'doesn\'t remove user\'s answer' do
        expect { delete :destroy, params: { question_id: question, id: answer } }.not_to \
          change(question.answers, :count)
      end
    end
  end

  describe 'GET #edit' do
    let!(:answer) { create(:answer, question: question, user: @user) }
    before { get :edit, xhr: true, params: { question_id: question, id: answer, format: :js } }

    it 'assigns answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders answer edit' do
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do
    let(:new_answer_attrs) { attributes_for(:answer) }

    context 'done by owner' do
      let!(:answer) { create(:answer, question: question, user: @user) }

      context 'with valid attributes' do
        it 'assigns answer\'s user and question' do
          patch :update, params: { question_id: question, id: answer, answer: new_answer_attrs, format: :js }

          expect(assigns(:answer).user).to eq @user
          expect(assigns(:answer).question).to eq question
        end

        it 'edits answer in db' do
          patch :update, params: { question_id: question, id: answer, answer: { body: 'new answer body' }, format: :js }

          answer.reload

          expect(answer.body).to eq 'new answer body'
        end

        it 'renders answer update' do
          patch :update, params: { question_id: question, id: answer, answer: new_answer_attrs, format: :js }

          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        let(:invalid_answer_attrs) { attributes_for(:invalid_answer) }

        it 'doesn\'t change the question in db' do
          initial_body = answer.body
          initial_question = answer.question
          initial_user = answer.user

          patch :update, params: { question_id: question, id: answer, answer: invalid_answer_attrs, format: :js }

          answer.reload

          expect(answer.body).to eq initial_body
          expect(answer.question).to eq initial_question
          expect(answer.user).to eq initial_user
        end

        it 'renders answer update' do
          patch :update, params: { question_id: question, id: answer, answer: invalid_answer_attrs, format: :js }

          expect(response).to render_template :update
        end
      end
    end

    context 'done by another user' do
      let!(:answer) { create(:answer, question: question, user: create(:user)) }

      it 'doesn\'t save the new question to db' do
        initial_body = answer.body
        initial_question = answer.question
        initial_user = answer.user

        patch :update, params: { question_id: question, id: answer, answer: new_answer_attrs, format: :js }

        answer.reload

        expect(answer.body).to eq initial_body
        expect(answer.question).to eq initial_question
        expect(answer.user).to eq initial_user
      end

      it 'renders answer update' do
        patch :update, params: { question_id: question, id: answer, answer: new_answer_attrs, format: :js }

        expect(response).to render_template :update
      end
    end
  end
end
