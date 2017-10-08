# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  describe 'POST #create' do
    sign_in_user

    let(:question) { create(:question) }
    let(:answer) { create(:answer) }

    context 'with valid attributes' do
      it 'votes for Question' do
        votable = question
        expect { post :create, params: { votable_type: votable.class, votable_id: votable.id, value: 1, vote_type: :up, format: :json } }.to change(votable, :rating).by(1)
        expect { post :create, params: { votable_type: votable.class, votable_id: votable.id, value: 1, vote_type: :up, format: :json } }.to change(votable, :rating).by(-1)
      end

      it 'votes for Answer' do
        votable = answer
        expect { post :create, params: { votable_type: votable.class, votable_id: votable.id, value: 1, vote_type: :up, format: :json } }.to change(votable, :rating).by(1)
        expect { post :create, params: { votable_type: votable.class, votable_id: votable.id, value: 1, vote_type: :up, format: :json } }.to change(votable, :rating).by(-1)
      end

      it 'renders json' do
        votable = question
        post :create, params: { votable_type: votable.class, votable_id: votable.id, value: 1, vote_type: :up, format: :json }
        expect(response.body).to eq Hash[rating: votable.rating].to_json

        votable = answer
        post :create, params: { votable_type: votable.class, votable_id: votable.id, value: 1, vote_type: :up, format: :json }

        expect(response).to have_http_status(:success)
        expect(response.body).to eq Hash[rating: votable.rating].to_json
      end
    end

    context 'with invalid attributes' do
      let(:own_question) { create(:question, user: @user) }

      it 'votes for own Question' do
        votable = own_question
        expect { post :create, params: { votable_type: votable.class, votable_id: votable.id, value: 1, vote_type: :up, format: :json } }.to change(votable, :rating).by(0)

        expect(response).to have_http_status(:forbidden)
      end

      it 'doesn\'t reset votes for Question' do
        votable = question
        expect { post :create, params: { votable_type: votable.class, votable_id: votable.id, value: 1, vote_type: :up, format: :json } }.to change(votable, :rating).by(1)
        expect { post :create, params: { votable_type: votable.class, votable_id: votable.id, value: -1, vote_type: :down, format: :json } }.to change(votable, :rating).by(0)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
