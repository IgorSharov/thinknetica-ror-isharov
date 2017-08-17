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
end
