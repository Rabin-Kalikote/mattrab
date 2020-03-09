class UsersController < ApplicationController
  #prevents if any other actions are not to be accessible.
  before_action :authenticate_user!#, except: [:show]
  def show
    @user = User.find(params[:id])
    @user_notes = @user.notes.all.order("created_at DESC")
  end
end
