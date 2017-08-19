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
end
