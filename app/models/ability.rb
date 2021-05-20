# frozen_string_literal: true

class Ability
  include CanCan::Ability
  def initialize(user)

    # anybody can
    can :read, :all
    can :search, Note
    can :home, Note #displays global home view.

    # nobody can
    cannot :create, Note
    cannot :read, Note, status: 'draft'
    cannot :verify, Note
    cannot :import, Note
    cannot :change_role, User

    return unless user.present?
    can :vote, Note
    can :vote, Question
    can :vote, Answer
    can :manage, Question, user_id: user.id
    can :manage, Answer, user_id: user.id
    can :manage, Answer, question: { user: { id: user.id } }

    return unless user.creator? or user.admin? or user.executive? or user.teacher? or user.superadmin?
    can :manage, Question, note: { user: { id: user.id } }
    can :manage, Answer, question: { note: { user: { id: user.id } } }
    can :manage, Note, user_id: user.id
    cannot :verify, Note
    cannot :import, Note

    return unless user.admin? or user.executive? or user.teacher? or user.superadmin?
    can :manage, Note
    can :manage, Question
    can :manage, Answer
    cannot :import, Note

    return unless user.superadmin?
    can :import, Note
    can :change_role, User

    # # anybody can
    # can :read, :all
    # can :search, Note
    # can :home, Note #displays global home view.
    #
    # # nobody can
    # cannot :create, Note
    # cannot :read, Note, status: 'draft'
    # cannot :verify, Note
    #
    # return unless user.present?
    # can :vote, Note
    # can :create, Question
    # can :manage, Question, user_id: user.id
    # can :vote, Question
    # can :vote, Answer
    #
    # return unless user.creator? or user.admin?
    # can :manage, Question, note: { user: { id: user.id } }
    # can :create, Answer
    # can :manage, Answer, question: { note: { user: { id: user.id } } }
    # can :manage, Answer, question: { user: { id: user.id } }
    # can :manage, Answer, user_id: user.id
    # can :manage, Note, user_id: user.id
    # cannot :verify, Note
    #
    # return unless user.admin?
    # can :manage, Note
    # can :manage, Question
    # can :manage, Answer

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
