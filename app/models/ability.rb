# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all
    return unless user
    can :create, [Question, Answer, Comment, Vote]
    can :update, [Question, Answer], user: user
    can :destroy, [Question, Answer], user: user
    can :best, Answer, question: { user: user }
    can :destroy, Attachment, attachable: { user: user }
  end
end
