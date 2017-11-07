# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'shows a list of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'creates a new Question object' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders view for New item' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      let(:question_attrs) { attributes_for(:question) }

      it 'assigns question\'s user' do
        post :create, params: { question: question_attrs }

        expect(assigns(:question).user).to eq @user
      end

      it 'saves the new question to db' do
        expect { post :create, params: { question: question_attrs } }.to change(Question, :count).by(1)
      end

      it 'redirects to question' do
        post :create, params: { question: question_attrs }

        expect(response).to redirect_to root_path
      end
    end

    context 'with invalid attributes' do
      let(:invalid_question_attrs) { attributes_for(:invalid_question) }

      it 'doesn\'t save the new question to db' do
        expect { post :create, params: { question: invalid_question_attrs } }.not_to change(Question, :count)
      end

      it 'renders view for the new question' do
        post :create, params: { question: invalid_question_attrs }

        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question_with_answers) }

    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'shows a list of all answers for the question' do
      expect(assigns(:question).answers).to match_array(question.answers)
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    context 'done by owner' do
      let!(:question) { create(:question, user: @user) }

      it 'removes the question with its answers' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to root' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to root_path
      end
    end

    context 'done by another user' do
      let!(:question) { create(:question, user: create(:user)) }

      it 'doesn\'t remove the question' do
        expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    let(:new_question_attrs) { attributes_for(:question) }

    context 'done by owner' do
      let!(:question) { create(:question, user: @user) }

      context 'with valid attributes' do
        it 'assigns question\'s user' do
          patch :update, params: { id: question, question: new_question_attrs, format: :js }

          expect(assigns(:question)).to eq question
          expect(assigns(:question).user).to eq @user
        end

        it 'edits question in db' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }

          question.reload

          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'renders question update' do
          patch :update, params: { id: question, question: new_question_attrs, format: :js }

          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        let(:invalid_question_attrs) { attributes_for(:invalid_question) }

        it 'doesn\'t change the question in db' do
          initial_title = question.title
          initial_body = question.body
          initial_user = question.user

          patch :update, params: { id: question, question: invalid_question_attrs, format: :js }

          question.reload

          expect(question.title).to eq initial_title
          expect(question.body).to eq initial_body
          expect(question.user).to eq initial_user
        end

        it 'renders question update' do
          patch :update, params: { id: question, question: invalid_question_attrs, format: :js }

          expect(response).to render_template :update
        end
      end
    end

    context 'done by another user' do
      let!(:question) { create(:question, user: create(:user)) }

      it 'doesn\'t save the new question to db' do
        initial_title = question.title
        initial_body = question.body
        initial_user = question.user

        patch :update, params: { id: question, question: new_question_attrs, format: :js }

        question.reload

        expect(question.title).to eq initial_title
        expect(question.body).to eq initial_body
        expect(question.user).to eq initial_user
      end

      it 'renders answer update' do
        patch :update, params: { id: question, question: new_question_attrs, format: :js }

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
