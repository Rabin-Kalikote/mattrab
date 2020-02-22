# frozen_string_literal: true

class Ability
  include CanCan::Ability
  def initialize(user)

    # anybody can
    can :read, :all
    can :search, Note
    can :create, Note # devise will ask for signin/login.

    # nobody can
    cannot :read, Note, status: 'draft'
    cannot :verify, Note

    return unless user.present?
    can :manage, Note, user_id: user.id
    can :manage, Question, note: { user: { id: user.id } }
    can :manage, Question, user_id: user.id
    can :vote, Note

    return unless user.creator?
    can :manage, Answer, note: { question: { user: { id: user.id } } }
    can :manage, Answer, question: { user: { id: user.id } }
    can :manage, Answer, user_id: user.id

    return unless user.admin?
    can :read, Note, status: 'draft'
    can :verify, Note
    can :manage, Note
    can :manage, Question
    can :manage, Answer
  end
end
