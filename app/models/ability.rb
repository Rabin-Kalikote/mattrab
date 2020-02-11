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

    return unless user.admin?
    can :manage, Note
    can :manage, Question
  end
end
