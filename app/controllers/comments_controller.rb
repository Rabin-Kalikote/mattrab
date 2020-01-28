class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_note
  def create
    @comment = @note.comments.new(comment_params)
    @comment.user_id = current_user.id
    @comment.save
  end

  def destroy
    @comment = @note.comments.find(params[:id])
    @comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :note_id)
  end

  def find_note
    @note = Note.find(params[:note_id])
  end
end
