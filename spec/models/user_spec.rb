# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should validate_uniqueness_of(:email).case_insensitive }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:auth_accounts).dependent(:destroy) }

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:another_question) { create(:question) }

    it 'checks for owner' do
      expect(user).to be_author_of question
    end
    it 'checks for another user' do
      expect(user).not_to be_author_of another_question
    end
  end

  describe 'rating methods' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:answer) { create(:answer) }
    let!(:vote_for_question) { create(:vote, votable: question, user: user) }
    let!(:vote_for_answer) { create(:vote, votable: answer, user: user) }

    it 'gets user\'s rating of the object' do
      expect(user.rating_of(question)).to eq 1
      expect(user.rating_of(answer)).to eq 1
    end

    it 'gets user\'s previous vote for the object' do
      expect(user.previous_vote_for(question)).to eq vote_for_question
      expect(user.previous_vote_for(answer)).to eq vote_for_answer
    end
  end

  describe '.find_or_create_for_auth' do
    let!(:user) { create(:user) }

    context 'auth provides email' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }

      context 'user already has auth account' do
        it 'returns user' do
          user.auth_accounts.create(provider: 'facebook', uid: '123456')
          expect(User.find_or_create_for_auth(auth)).to eq user
        end
      end

      context 'user doesn\'t have auth account' do
        context 'user already exists' do
          it 'doesn\'t create new user' do
            expect { User.find_or_create_for_auth(auth) }.not_to change(User, :count)
          end

          it 'creates auth account for user' do
            expect { User.find_or_create_for_auth(auth) }.to change(user.auth_accounts, :count).by(1)
          end

          it 'creates auth account with provider and uid' do
            auth_account = User.find_or_create_for_auth(auth).auth_accounts.first

            expect(auth_account.provider).to eq auth.provider
            expect(auth_account.uid).to eq auth.uid
          end

          it 'returns the user' do
            expect(User.find_or_create_for_auth(auth)).to eq user
          end
        end

        # TODO: repair
        # Failure/Error: <p><%= link_to 'Confirm my account', confirmation_url(@resource, confirmation_token: @token) %></p>
        # ActionView::Template::Error:
        # Missing host to link to! Please provide the :host parameter, set default_url_options[:host], or set :only_path to true
        #   ./app/views/devise/mailer/confirmation_instructions.html.erb:5:in `_app_views_devise_mailer_confirmation_instructions_html_erb___204209578_45532836'
        context 'user doesn\'t exist' do
          let(:auth_for_new_user) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'user@example.lo' }) }

          it 'creates new user' do
            expect { User.find_or_create_for_auth(auth_for_new_user) }.to change(User, :count).by(1)
          end

          it 'returns new user' do
            expect(User.find_or_create_for_auth(auth_for_new_user)).to be_a(User)
          end

          it 'fills user email' do
            user = User.find_or_create_for_auth(auth_for_new_user)
            expect(user.email).to eq auth_for_new_user.info[:email]
          end

          it 'creates auth_account for user' do
            user = User.find_or_create_for_auth(auth_for_new_user)
            expect(user.authorizations).to_not be_empty
          end

          it 'creates auth_account with provider and uid' do
            auth_account = User.find_or_create_for_auth(auth_for_new_user).auth_accounts.first

            expect(auth_account.provider).to eq auth_for_new_user.provider
            expect(auth_account.uid).to eq auth_for_new_user.uid
          end
        end
      end
    end

    # TODO: develop
    context 'auth doesn\'t provide email'
  end
end
