class AnswersController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!
  before_action :find_question

  respond_to :html
  respond_to :js

  def create
    params[:answer][:content] = params[:answer][:content].gsub('source', '<span>source</span>').gsub('position: fixed', '<span>position: fixed</span>').gsub('position:fixed', '<span>position:fixed</span>').gsub('method="delete"', '').gsub('link', '<span>link</span>').gsub('script', '<span>script</span>').gsub("method='delete'", '').gsub(/<iframe .*src="(https?:\/\/)?(?!(?:\/\/www.youtube.com\/embed\/|\/\/player.vimeo.com\/video\/)).*><\/iframe>/, '')
                                .gsub('onerror', '<span>onerror</span>').gsub('onclick', '<span>onclick</span>').gsub('onload', '<span>onload</span>').gsub('onchange', '<span>onchange</span>').gsub('onmouseover', '<span>onmouseover</span>').gsub('onmouseout', '<span>onmouseout</span>').gsub('onmousedown', '<span>onmousedown</span>').gsub('onmouseup', '<span>onmouseup</span>').gsub('onfocus', '<span>onfocus</span>').gsub(/[\r\n]+/, ' ').html_safe
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
    params[:answer][:content] = params[:answer][:content].gsub('source', '<span>source</span>').gsub('position: fixed', '<span>position: fixed</span>').gsub('position:fixed', '<span>position:fixed</span>').gsub('method="delete"', '').gsub('link', '<span>link</span>').gsub('script', '<span>script</span>').gsub("method='delete'", '').gsub(/<iframe .*src="(https?:\/\/)?(?!(?:\/\/www.youtube.com\/embed\/|\/\/player.vimeo.com\/video\/)).*><\/iframe>/, '')
                                .gsub('onerror', '<span>onerror</span>').gsub('onclick', '<span>onclick</span>').gsub('onload', '<span>onload</span>').gsub('onchange', '<span>onchange</span>').gsub('onmouseover', '<span>onmouseover</span>').gsub('onmouseout', '<span>onmouseout</span>').gsub('onmousedown', '<span>onmousedown</span>').gsub('onmouseup', '<span>onmouseup</span>').gsub('onfocus', '<span>onfocus</span>').gsub(/[\r\n]+/, ' ').html_safe
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
