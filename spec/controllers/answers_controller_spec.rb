# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { FactoryGirl.create(:question_with_answer) }

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'assings the question' do
      expect(assigns(:question)).to eq question
    end

    it 'assings the answer' do
      expect(assigns(:answer).question).to eq question
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:answer_attrs) { FactoryGirl.attributes_for(:answer) }

      it 'saves the new answer to db' do
        question
        expect { post :create, params: { question_id: question, answer: answer_attrs } }.to \
          change(Answer, :count).by(1)
      end

      it 'redirects to question' do
        post :create, params: { question_id: question, answer: answer_attrs }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      let(:invalid_answer_attrs) { FactoryGirl.attributes_for(:invalid_answer) }

      it 'doesn\'t save the new question to db' do
        question
        expect { post :create, params: { question_id: question, answer: invalid_answer_attrs } }.not_to \
          change(Answer, :count)
      end

      it 'renders view for the new question' do
        post :create, params: { question_id: question, answer: invalid_answer_attrs }
        expect(response).to render_template :new
      end
    end
  end
end
