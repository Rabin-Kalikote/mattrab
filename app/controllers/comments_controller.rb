class CommentsController < ApplicationController
  before_action :authenticate_user!
  def create
    @note = Note.find(params[:note_id])
    @comment = Comment.create(params[:comment].permit(:content))
    @comment.user_id = current_user.id
    @comment.note_id = @note.id

    if @comment.save
      redirect_to note_path(@note)
    else
      render 'new'
    end
  end
end
