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
    can :update, Note, user_id: user.id
    can :destroy, Note, user_id: user.id
    can :upvote, Note
    can :downvote, Note
    can :destroy, Comment, user_id: user.id
    return unless user.admin?
    can :manage, :all
  end
end
