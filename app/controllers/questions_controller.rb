class QuestionsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_parent, only: [:show, :create, :edit, :update, :destroy]

  respond_to :html
  respond_to :js

  def index
    params[:grade].present? ? @grade = params[:grade] : @grade = 'twelve'
    params[:category].present? ? @category = params[:category] : @category = 'physics'
    params[:chapter].present? ? @chapter = params[:chapter] : @chapter = 1

    @notes = Note.joins(:grade).where(grades: { name: @grade }).
                  joins(:category).where(categories: { name: @category }).
                  joins(:chapter).where(chapters: { id: @chapter }).
                  published.order("created_at ASC")
    @questions = Question.joins(:grade).where(grades: { name: @grade }).
                  joins(:category).where(categories: { name: @category }).
                  joins(:chapter).where(chapters: { id: @chapter }).
                  order("created_at ASC")

    set_meta_tags title: "Class #{@grade.humanize} #{@category.humanize}: #{Chapter.find(@chapter).name}", site: 'Mattrab', description: "Browse high-quality notes, questions, and answers for #{Chapter.find(@chapter).name} of class #{@grade} #{@category} subject.", keywords: "Class #{@grade}, #{@category}, #{Chapter.find(@chapter).name}, notes for class #{@grade} #{@category}, notes for #{Chapter.find(@chapter).name}, question answer for class #{@grade} #{@category}",
                  og: { title: "Class #{@grade.humanize} #{@category.humanize}: #{Chapter.find(@chapter).name}", description: "Browse high-quality notes, questions, and answers for #{Chapter.find(@chapter).name} of class #{@grade} #{@category} subject.", type: 'website', url: notes_url(:grade=>"#{@grade}", :category=>"#{@category}", :chapter=>@chapter)},
                  twitter: { title: "Class #{@grade.humanize} #{@category.humanize}: #{Chapter.find(@chapter).name}", description: "Browse high-quality notes, questions, and answers for #{Chapter.find(@chapter).name} of class #{@grade} #{@category} subject." }
  end

  def show
    set_meta_tags title: @question.content.gsub(/<[^>]*>/, '').truncate(50), site: 'Mattrab', description: @question.content.gsub(/<[^>]*>/, '').truncate(150), keywords: "#{@question.chapter.name}, question on #{@question.chapter.name}, class #{@question.grade.name} #{@question.category.name} note, class #{@question.grade.name} questions, #{@question.chapter.name} questions", author: @question.user.name,
                  og: { title: @question.content.gsub(/<[^>]*>/, '').truncate(50), description: @question.content.gsub(/<[^>]*>/, '').truncate(150), type: 'website', url: question_url(@question) },
                  twitter: { title: @question.content.gsub(/<[^>]*>/, '').truncate(50), description: @question.content.gsub(/<[^>]*>/, '').truncate(150) }

    @question.update_attribute "view", @question.view += 1
    @answers = @question.answers.order(:cached_votes_up => :desc)
    respond_with(@answers)
  end

  def create
    if params[:note_id].present?
      params[:question][:content] = params[:question][:content].gsub('source', '<span>source</span>').gsub('position: fixed', '<span>position: fixed</span>').gsub('position:fixed', '<span>position:fixed</span>').gsub('method="delete"', '').gsub('link', '<span>link</span>').gsub('script', '<span>script</span>').gsub("method='delete'", '').gsub(/<iframe .*src="(https?:\/\/)?(?!(?:\/\/www.youtube.com\/embed\/|\/\/player.vimeo.com\/video\/)).*><\/iframe>/, '')
                                  .gsub('onerror', '<span>onerror</span>').gsub('onclick', '<span>onclick</span>').gsub('onload', '<span>onload</span>').gsub('onchange', '<span>onchange</span>').gsub('onmouseover', '<span>onmouseover</span>').gsub('onmouseout', '<span>onmouseout</span>').gsub('onmousedown', '<span>onmousedown</span>').gsub('onmouseup', '<span>onmouseup</span>').gsub('onfocus', '<span>onfocus</span>').html_safe
      @question = @note.questions.new(question_params)
      @question.user_id = current_user.id
      @question.grade_id = @note.grade.id
      @question.category_id = @note.category.id
      @question.chapter_id = @note.chapter.id
      @question.save
    else
      @question = current_user.questions.build(question_params)
      if @question.save
        redirect_to question_url(@question), notice: 'Question created successfully.'
      else
        render 'new'
      end
    end
  end

  def new
    @question = current_user.questions.build
  end

  def edit
    set_meta_tags title: 'Edit '+@question.content.gsub(/<[^>]*>/, '').truncate(50), site: 'Mattrab'
  end

  def update
    params[:question][:content] = params[:question][:content].gsub('source', '<span>source</span>').gsub('position: fixed', '<span>position: fixed</span>').gsub('position:fixed', '<span>position:fixed</span>').gsub('method="delete"', '').gsub('link', '<span>link</span>').gsub('script', '<span>script</span>').gsub("method='delete'", '').gsub(/<iframe .*src="(https?:\/\/)?(?!(?:\/\/www.youtube.com\/embed\/|\/\/player.vimeo.com\/video\/)).*><\/iframe>/, '')
                                .gsub('onerror', '<span>onerror</span>').gsub('onclick', '<span>onclick</span>').gsub('onload', '<span>onload</span>').gsub('onchange', '<span>onchange</span>').gsub('onmouseover', '<span>onmouseover</span>').gsub('onmouseout', '<span>onmouseout</span>').gsub('onmousedown', '<span>onmousedown</span>').gsub('onmouseup', '<span>onmouseup</span>').gsub('onfocus', '<span>onfocus</span>').html_safe
    if @question.update(question_params)
      redirect_to @question, notice: 'Question updated successfully.'
    else
      render 'edit'
    end
  end

  def destroy
    if params[:note_id].present?
      @question = @note.questions.find(params[:id])
      @question.destroy
    else
      @question.destroy
      redirect_to questions_path, notice: 'Question deleted successfully.'
    end
  end

  def vote
    if !current_user.liked? @question
      @question.liked_by current_user
    else
      @question.unliked_by current_user
    end
    render :json => { :count => @question.get_upvotes.size }
  end

  private

  def question_params
    params.require(:question).permit(:content, :note_id, :grade_id, :category_id, :chapter_id)
  end

  def find_parent
    if params[:note_id].present?
      @note = Note.find(params[:note_id])
    elsif params[:id].present?
      @question = Question.find(params[:id])
    end
  end
end
