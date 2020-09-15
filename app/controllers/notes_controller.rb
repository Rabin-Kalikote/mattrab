class NotesController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!, except: [:home, :index, :show, :search]
  before_action :find_note, only: [:show, :edit, :update, :destroy, :vote, :verify]

  def home
    @question_tags = Question.tag_counts.limit(25)
    @question = Question.find_by_id(10)

    if user_signed_in?
      # created_notes = Note.where('updated_at > ?', 24.hours.ago).where()
      # if followed users have created any notes
      notes = Note.where(user_id: User.find(1).following).where('updated_at > ?', 24.hours.ago)
      created_notes = notes.where('updated_at = created_at')
      updated_notes = notes.where.not('updated_at = created_at')
      #
      # asked_qns_lib =
      # asked_qns_note =
      # answers_to_note =
    else

    end

    @note_tags = Note.tag_counts.limit(25)

    if user_signed_in? #and !current_user.teacher?
      if current_user.categories.present?
        @notes = Note.joins(:grade).where(grades: { name: current_user.grade.name }).
                      joins(:category).merge(current_user.categories).
                      published.order("RANDOM()").limit(8)
      else
        @notes = Note.joins(:grade).where(grades: { name: current_user.grade.name }).
                      published.order("RANDOM()").limit(8)
      end
      @questions = Question.joins(:grade).where(grades: { name: current_user.grade.name }).order("RANDOM()").limit(8)
    else
      @notes = Note.published.order("RANDOM()").limit(8)
      @questions = Question.all.order("RANDOM()").limit(8)
    end
    @category_title = "Recommended"
  end

  def index
    if params[:category].present?
      if user_signed_in? #and !current_user.teacher?
        @notes = Note.joins(:grade).where(grades: { name: current_user.grade.name }).
                      joins(:category).where(categories: { name: params[:category] }).
                      published.paginate(page: params[:page], per_page: 14).order("RANDOM()")
      elsif params[:grade].present?
        @notes = Note.joins(:grade).where(grades: { name: params[:grade] }).
                      joins(:category).where(categories: { name: params[:category] }).
                      published.paginate(page: params[:page], per_page: 14).order("RANDOM()")
      else
        @notes = Note.joins(:category).where(categories: { name: params[:category] }).
                      published.paginate(page: params[:page], per_page: 14).order("RANDOM()")
      end
    elsif params[:tag].present?
      if user_signed_in? #and !current_user.teacher?
        @notes = Note.tagged_with(params[:tag]).joins(:grade).where(grades: { name: current_user.grade.name }).
                      joins(:category).merge(current_user.categories).
                      published.paginate(page: params[:page], per_page: 14).order("RANDOM()")
      else
        @notes = Note.tagged_with(params[:tag]).joins(:category).merge(current_user.categories).published.paginate(page: params[:page], per_page: 14).order("RANDOM()")
      end
    else
      if user_signed_in? #and !current_user.teacher?
        @notes = Note.joins(:grade).where(grades: { name: current_user.grade.name }).
                      joins(:category).merge(current_user.categories).
                      published.paginate(page: params[:page], per_page: 14).order("RANDOM()")
      elsif params[:grade].present?
        @notes = Note.joins(:grade).where(grades: { name: params[:grade] }).
                      published.paginate(page: params[:page], per_page: 14).order("RANDOM()")
      else
        @notes = Note.published.paginate(page: params[:page], per_page: 14).order("RANDOM()")
      end
    end
  end

  def show
    set_meta_tags title: @note.title, site: 'Mattrab', description: @note.body.gsub(/<[^>]*>/, '').truncate(150), keywords: @note.category.name+" class "+@note.grade.name,
                  og: { title: @note.title, description: @note.body.gsub(/<[^>]*>/, '').truncate(150), type: 'website', url: note_url(@note), image: @note.image },
                  twitter: { card: 'note', site: '@askmattrab', title: @note.title, description: @note.body.gsub(/<[^>]*>/, '').truncate(150), image: @note.image }
    @questions = Question.where(note_id: @note).order("created_at DESC")
    if user_signed_in?
      @random_note = Note.joins(:grade).where(grades: { name: current_user.grade.name }).
                          joins(:category).where(categories: { name: @note.category.name }).
                          published.where.not(id: @note).order("RANDOM()").first
    else
      @random_note = Note.joins(:category).where(categories: { name: @note.category.name }).
                          published.where.not(id: @note).order("RANDOM()").first
    end
    @random_note = Note.published.where.not(id: @note).order("RANDOM()").first if !@random_note.present?
    @note.update_attribute "view", @note.view += 1
  end

  def new
    @note = current_user.notes.build
  end

  def create
    @note = current_user.notes.build(note_params)

    if @note.save
      redirect_to edit_note_url(@note)
    else
      render 'new'
    end
  end

  def edit
    @admins = UserCategorization.where(:category_id => @note.category.id).joins(:user).merge(User.admin).map(&:user)
    @admins = User.admin if !@admins.present?
    set_meta_tags title: 'Edit '+@note.title, site: 'Mattrab'
  end

  def update
    if @note.update(note_params)
      redirect_to @note
    else
      render 'edit'
    end
  end

  def destroy
    @note.destroy
    redirect_to root_path
  end

  def vote
    if !current_user.liked? @note
      @note.liked_by current_user
    else
      @note.unliked_by current_user
    end
    render :json => { :count => @note.get_upvotes.size }
  end

  def verify
    @note.update_attribute(:is_verified, params[:is_verified])
    redirect_back fallback_location: @note
  end

  def request_verification
    @note.request_verification(User.find(params[:admin]))
    redirect_back fallback_location: @note
  end

  private

  def find_note
    @note = Note.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:title, :body, :image, :category, :status, :grade, :grade_id, :category_id, :tag_list)
  end
end
