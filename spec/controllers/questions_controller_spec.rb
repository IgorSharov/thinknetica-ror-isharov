# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    let(:questions) { FactoryGirl.create_list(:question, 2) }

    before { get :index }

    it 'shows a list of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'creates a new Question object' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders view for New item' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #create' do
    context 'with valid attributes' do
      it 'saves the new question to db' do
        expect { post :create, params: { question: FactoryGirl.attributes_for(:question) } }.to \
          change(Question, :count).by(1)
      end

      it 'redirects to index view' do
        post :create, params: { question: FactoryGirl.attributes_for(:question) }
        expect(response).to redirect_to questions_path
      end
    end

    context 'with invalid attributes' do
      it 'doesn\'t save the new question to db' do
        expect { post :create, params: { question: FactoryGirl.attributes_for(:invalid_question) } }.not_to \
          change(Question, :count)
      end

      it 'renders view for New item' do
        post :create, params: { question: FactoryGirl.attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end
end
