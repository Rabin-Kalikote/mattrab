class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_note
  def create
    @answer = Question.find(params[:question_id]).answers.new(answer_params)
    @answer.user_id = current_user.id
    @answer.save
  end

  def destroy
    @answer = @question.answers.find(params[:id])
    @answer.destroy
  end

  private

  def answer_params
    params.require(:answer).permit(:content, :question_id)
  end

  def find_note
    @note = Note.find(params[:note_id])
  end
end
