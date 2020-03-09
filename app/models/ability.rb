# frozen_string_literal: true

class Ability
  include CanCan::Ability
  def initialize(user)

    # anybody can
    can :read, :all
    can :search, Note

    # nobody can
    cannot :create, Note
    cannot :read, Note, status: 'draft'
    cannot :verify, Note

    return unless user.present?
    can :vote, Note
    can :create, Question
    can :manage, Question, user_id: user.id

    return unless user.creator? or user.admin?
    can :manage, Question, note: { user: { id: user.id } }
    can :manage, Answer, question: { note: { user: { id: user.id } } }
    can :manage, Answer, question: { user: { id: user.id } }
    can :manage, Answer, user_id: user.id
    can :manage, Answer
    can :manage, Note, user_id: user.id
    cannot :verify, Note

    return unless user.admin?
    can :manage, Note
    can :manage, Question

    # # anybody can
    # can :read, :all
    # can :search, Note
    # can :create, Note # devise will ask for signin/login.
    #
    # # nobody can
    # cannot :read, Note, status: 'draft'
    # cannot :verify, Note
    #
    # return unless user.present?
    # can :manage, Note, user_id: user.id
    # cannot :verify, Note
    # can :vote, Note
    # can :create, Question
    # can :manage, Question, note: { user: { id: user.id } }
    # can :manage, Question, user_id: user.id
    # can :manage, Answer, question: { note: { user: { id: user.id } } }
    # can :manage, Answer, question: { user: { id: user.id } }
    # can :manage, Answer, user_id: user.id
    #
    # return unless user.creator? or user.admin?
    # can :manage, Answer
    #
    # return unless user.admin?
    # can :manage, Note
    # can :manage, Question
  end
end
