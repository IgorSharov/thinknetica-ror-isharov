# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable,
         :confirmable,
         :omniauthable, omniauth_providers: %i[github vkontakte]

  has_many :answers, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :auth_accounts, dependent: :destroy

  scope :list_others, ->(id) { where('id != ?', id) }

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
    return unless auth.info
    email = auth.info[:email]
    return unless email
    if (user = find_by(email: email))
      user.create_auth_account(auth)
    else
      password = Devise.friendly_token[0, 20]
      user = User.new(email: email, password: password, password_confirmation: password)
      user.skip_confirmation!
      transaction do
        user.save!
        user.create_auth_account(auth)
      end
    end
    user
  end

  def self.find_and_send_confirmation_email(auth)
    user = find_or_create_for_auth(auth)
    return unless user
    user.confirmed_at = nil
    user.save
    user.send_confirmation_instructions
  end

  def create_auth_account(auth)
    auth_accounts.create!(provider: auth.provider, uid: auth.uid)
  end
end
