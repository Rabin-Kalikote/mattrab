class QuestionsController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_parent, only: [:show, :create, :edit, :update, :destroy]

  respond_to :html
  respond_to :js

  def index

    if params[:category].present?
      if user_signed_in? #and !current_user.teacher?
        @questions = Question.joins(:grade).where(grades: { name: current_user.grade.name }).
                      joins(:category).where(categories: { name: params[:category] }).
                      paginate(page: params[:page], per_page: 14).order("RANDOM()")
      elsif params[:grade].present?
        @questions = Question.joins(:grade).where(grades: { name: params[:grade] }).
                      joins(:category).where(categories: { name: params[:category] }).
                      paginate(page: params[:page], per_page: 14).order("RANDOM()")
      else
        @questions = Question.joins(:category).where(categories: { name: params[:category] }).
                      paginate(page: params[:page], per_page: 14).order("RANDOM()")
      end
    elsif params[:tag].present?
      if user_signed_in? #and !current_user.teacher?
        @questions = Question.tagged_with(params[:tag]).joins(:grade).where(grades: { name: current_user.grade.name }).
                      joins(:category).merge(current_user.categories).
                      paginate(page: params[:page], per_page: 14).order("RANDOM()")
      else
        @questions = Question.tagged_with(params[:tag]).joins(:category).merge(current_user.categories).published.paginate(page: params[:page], per_page: 14).order("RANDOM()")
      end
    else
      if user_signed_in? #and !current_user.teacher?
        @questions = Question.joins(:grade).where(grades: { name: current_user.grade.name }).
                      joins(:category).merge(current_user.categories).
                      paginate(page: params[:page], per_page: 14).order("RANDOM()")
      elsif params[:grade].present?
        @questions = Question.joins(:grade).where(grades: { name: params[:grade] }).
                      paginate(page: params[:page], per_page: 14).order("RANDOM()")
      else
        @questions = Question.paginate(page: params[:page], per_page: 14).order("RANDOM()")
      end
    end
  end

  def show
    set_meta_tags title: @question.content.gsub(/<[^>]*>/, '').truncate(50), site: 'Mattrab', description: @question.content.gsub(/<[^>]*>/, '').truncate(150), keywords: @question.category.name+" class "+@question.grade.name,
                  og: { title: @question.content.gsub(/<[^>]*>/, '').truncate(50), description: @question.content.gsub(/<[^>]*>/, '').truncate(150), type: 'website', url: question_url(@question) },
                  twitter: { card: 'question', site: '@askmattrab', title: @question.content.gsub(/<[^>]*>/, '').truncate(50), description: @question.content.gsub(/<[^>]*>/, '').truncate(150) }

    @question.update_attribute "view", @question.view += 1
    @answers = @question.answers.order(:cached_votes_up => :desc)
    respond_with(@answers)
  end

  def create
    if params[:note_id].present?
      @question = @note.questions.new(question_params)
      @question.user_id = current_user.id
      @question.grade_id = @note.grade.id
      @question.category_id = @note.category.id
      @question.tag_list = @note.tag_list
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
    params.require(:question).permit(:content, :note_id, :grade_id, :category_id, :tag_list)
  end

  def find_parent
    if params[:note_id].present?
      @note = Note.find(params[:note_id])
    elsif params[:id].present?
      @question = Question.find(params[:id])
    end
  end
end
