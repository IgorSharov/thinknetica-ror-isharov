# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all
    # API
    can %i[me index], :profile
    return unless user
    # create
    can :create, [Question, Answer, Comment, Vote]
    # update
    can :update, [Question, Answer], user: user
    # destroy
    can :destroy, [Question, Answer], user: user
    can :destroy, Attachment, attachable: { user: user }
    # custom
    can :best, Answer, question: { user: user }
  end
end
