class NotesController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!, except: [:home, :index, :show, :search]
  before_action :find_note, only: [:show, :edit, :update, :destroy, :vote, :verify]

  def home
    @question_tags = Question.tag_counts.limit(25)
    # global feeds
    if user_signed_in?
      notes = Note.published.where.not(user_id: current_user).order("created_at DESC, view DESC").limit(18).to_a
      questions = Question.where.not(user_id: current_user).order("created_at DESC, view DESC").limit(18).to_a
      general_feeds = notes.concat(questions).uniq.shuffle
      @feeds = general_feeds.concat(current_user.feeds).uniq.paginate(page: params[:page], per_page: 7)
    else
      notes = Note.published.order("created_at DESC, view DESC").limit(18).to_a
      questions = Question.all.order("created_at DESC, view DESC").limit(18).to_a
      general_feeds = notes.concat(questions).uniq.shuffle
      @feeds = general_feeds.paginate(page: params[:page], per_page: 7)
    end
    @top_creators = User.where(:role => 'creator').joins(:notes).group("users.id").order("count(users.id) DESC").limit(2)
    @top_learners = User.where(:role => 'learner').joins(:questions).group("users.id").order("count(users.id) DESC").limit(2)
    @recent_users = User.all.order("created_at DESC").limit(2)
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
    note_params[:content] = note_params[:content].gsub('position: fixed', '<span>position: fixed</span>').gsub('position:fixed', '<span>position:fixed</span>').gsub('method="delete"', '').gsub("method='delete'", '').gsub(/\biframe src="https?:\/\/(?!\S+(?:youtube|vimeo|vine|instagram|dailymotion|youku))\S+/, '&lt;iframe ').gsub(/\biframe \S+ src="https?:\/\/(?!\S+(?:youtube|vimeo|vine|instagram|dailymotion|youku))\S+/, '&lt;iframe ')
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
    note_params[:content] = note_params[:content].gsub('position: fixed', '<span>position: fixed</span>').gsub('position:fixed', '<span>position:fixed</span>').gsub('method="delete"', '').gsub("method='delete'", '').gsub(/\biframe src="https?:\/\/(?!\S+(?:youtube|vimeo|vine|instagram|dailymotion|youku))\S+/, '&lt;iframe ').gsub(/\biframe \S+ src="https?:\/\/(?!\S+(?:youtube|vimeo|vine|instagram|dailymotion|youku))\S+/, '&lt;iframe ')
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
