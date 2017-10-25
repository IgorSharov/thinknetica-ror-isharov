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

  context 'auth provides email' do
    describe '.find_or_create_for_auth' do
      let!(:user) { create(:user) }
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
            expect(user.auth_accounts).to_not be_empty
          end

          it 'creates auth_account with provider and uid' do
            auth_account = User.find_or_create_for_auth(auth_for_new_user).auth_accounts.first

            expect(auth_account.provider).to eq auth_for_new_user.provider
            expect(auth_account.uid).to eq auth_for_new_user.uid
          end
        end
      end
    end
  end

  context 'auth doesn\'t provide email' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }

    describe '.find_and_send_confirmation_email' do
      it 'sends a mail' do
        expect(User.find_and_send_confirmation_email(auth)).to be_a(Mail::Message)
      end

      it 'disconfirms existing user' do
        User.find_and_send_confirmation_email(auth)
        user.reload
        expect(user.confirmed_at).to eq nil
      end
    end
  end
end
