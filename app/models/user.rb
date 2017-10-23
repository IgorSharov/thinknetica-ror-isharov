# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:vkontakte]

  has_many :answers, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :auth_accounts, dependent: :destroy

  def author_of?(object)
    object.user_id == id
  end

  def rating_of(votable)
    votes.where(votable_type: votable.class.name, votable_id: votable.id).sum(:value)
  end

  def previous_vote_for(votable)
    user_votes = votes.where(votable_type: votable.class.name, votable_id: votable.id)
    user_votes.last if user_votes.size.odd?
  end

  def self.find_or_create_for_auth(auth)
    authorization = AuthAccount.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user if authorization
    email = auth.info[:email]
    return unless email
    if (user = find_by(email: email))
      user.create_auth_account(auth)
    else
      password = Devise.friendly_token[0, 20]
      transaction do
        user = create!(email: email, password: password, password_confirmation: password)
        user.create_auth_account(auth)
      end
    end
    user
  end

  def create_auth_account(auth)
    auth_accounts.create(provider: auth.provider, uid: auth.uid)
  end
end
