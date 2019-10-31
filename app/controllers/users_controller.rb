class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @user_notes = @user.notes.all.order("created_at DESC")
  end
end
