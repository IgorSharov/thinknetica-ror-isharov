# frozen_string_literal: true

class AuthAccount < ApplicationRecord
  belongs_to :user

  validates :provider, :uid, presence: true
end
