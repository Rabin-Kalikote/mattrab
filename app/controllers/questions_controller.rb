class QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_note
  def create
    @question = @note.questions.new(question_params)
    @question.user_id = current_user.id
    @question.save
  end

  def destroy
    @question = @note.questions.find(params[:id])
    @question.destroy
  end

  private

  def question_params
    params.require(:question).permit(:content, :note_id)
  end

  def find_note
    @note = Note.find(params[:note_id])
  end
end
