class AnswersController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!
  before_action :find_question

  respond_to :html
  respond_to :js

  def create
    answer_params[:content] = answer_params[:content].gsub('position: fixed', '<span>position: fixed</span>').gsub('position:fixed', '<span>position:fixed</span>').gsub('method="delete"', '').gsub("method='delete'", '').gsub(/\biframe src="https?:\/\/(?!\S+(?:youtube|vimeo|vine|instagram|dailymotion|youku))\S+/, '&lt;iframe ').gsub(/\biframe \S+ src="https?:\/\/(?!\S+(?:youtube|vimeo|vine|instagram|dailymotion|youku))\S+/, '&lt;iframe ')
    @answer = @question.answers.new(answer_params)
    @answer.user_id = current_user.id
    @answer.save
  end

  def new
    @answer = @question.answers.new
    respond_with(@answer)
  end

  def edit
    @answer = @question.answers.find(params[:id])
  end

  def update
    answer_params[:content] = answer_params[:content].gsub('position: fixed', '<span>position: fixed</span>').gsub('position:fixed', '<span>position:fixed</span>').gsub('method="delete"', '').gsub("method='delete'", '').gsub(/\biframe src="https?:\/\/(?!\S+(?:youtube|vimeo|vine|instagram|dailymotion|youku))\S+/, '&lt;iframe ').gsub(/\biframe \S+ src="https?:\/\/(?!\S+(?:youtube|vimeo|vine|instagram|dailymotion|youku))\S+/, '&lt;iframe ')
    @answer = @question.answers.find(params[:id])
    @answer.update(answer_params)
    respond_with(@answer)
  end

  def destroy
    @answer = @question.answers.find(params[:id])
    @answer.destroy
    respond_with(@answer)
  end

  def vote
    @answer = @question.answers.find(params[:answer_id])
    if !current_user.liked? @answer
      @answer.liked_by current_user
    else
      @answer.unliked_by current_user
    end
    render :json => { :count => @answer.get_upvotes.size }
  end

  private

  def answer_params
    params.require(:answer).permit(:content, :question_id)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
