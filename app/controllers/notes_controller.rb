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
    @top_creators = User.where(:role => 'creator').joins(:notes).where("notes.status = ?", 1).group("users.id").order("count(users.id) DESC").limit(3)
    @top_learners = User.where(:role => 'learner').joins(:questions).group("users.id").order("count(users.id) DESC").limit(3)
    @recent_users = User.all.order("created_at DESC").limit(2)
    @icons = {'physics'=>'satellite', 'chemistry'=>'flask', 'biology'=>'microscope', 'maths'=>'subscript', 'computer'=>'plug', 'english'=>'sort-alpha-up-alt', 'nepali'=>'torah', 'economics'=>'chart-line', 'account'=>'funnel-dollar', 'science'=>'magnet', 'social'=>'globe-asia', 'health'=>'walking', 'moral'=>'balance-scale', 'obt'=>'chart-bar', 'opt_math'=>'square-root-alt', 'pastpapers'=>'paste', 'solution'=>'pencil-ruler', 'trivia'=>'bullhorn', 'philosopy'=>'hourglass-start'}
  end

  def index
    params[:grade].present? ? @grade = params[:grade] : @grade = 'twelve'
    if params[:category].present?
      @category = params[:category]
      category_id = Category.joins(:grade).where(grades: { name: @grade }, name: params[:category]).first.id
    else
      @category = Category.joins(:grade).where(grades: { name: @grade }).first.name
      category_id = Category.joins(:grade).where(grades: { name: @grade }).first.id
    end
    params[:chapter].present? ? @chapter = params[:chapter] : @chapter = Chapter.joins(:category).where(categories: {id: category_id}).first.id

    @notes = Note.joins(:grade).where(grades: { name: @grade }).
                  joins(:category).where(categories: { id: category_id }).
                  joins(:chapter).where(chapters: { id: @chapter }).
                  published.order("created_at ASC")
    @questions = Question.joins(:grade).where(grades: { name: @grade }).
                  joins(:category).where(categories: { id: category_id }).
                  joins(:chapter).where(chapters: { id: @chapter }).
                  order("created_at ASC")

    set_meta_tags title: "Class #{@grade.humanize} #{@category.humanize}: #{Chapter.find(@chapter).name}", site: 'Mattrab', description: "Class #{@grade.humanize} #{@category.humanize} notes for #{Chapter.find(@chapter).name} chapter", keywords: "Class #{@grade.humanize} #{@category.humanize} #{Chapter.find(@chapter).name} notes",
                  og: { title: "Class #{@grade.humanize} #{@category.humanize}: #{Chapter.find(@chapter).name}", description: "Class #{@grade.humanize} #{@category.humanize} #{Chapter.find(@chapter).name} notes", type: 'website', url: notes_url(:grade=>"#{@grade}", :category=>"#{@category}", :chapter=>@chapter)},
                  twitter: { card: 'note', site: '@askmattrab', title: "Class #{@grade.humanize} #{@category.humanize}: #{Chapter.find(@chapter).name}", description: "Class #{@grade.humanize} #{@category.humanize} #{Chapter.find(@chapter).name} notes" }
  end

  def show
    set_meta_tags title: @note.title, site: 'Mattrab', description: @note.body.gsub(/<[^>]*>/, '').truncate(150), keywords: @note.category.name+" class "+@note.grade.name,
                  og: { title: @note.title, description: @note.body.gsub(/<[^>]*>/, '').truncate(150), type: 'website', url: note_url(@note), image: @note.image },
                  twitter: { card: 'note', site: '@askmattrab', title: @note.title, description: @note.body.gsub(/<[^>]*>/, '').truncate(150), image: @note.image }
    @questions = Question.where(note_id: @note).order("created_at DESC")
    @random_note = Note.joins(:chapter).where(chapters: { id: @note.chapter.id }).
                          published.where.not(id: @note).order("RANDOM()").first
    @random_note = Note.joins(:category).where(categories: { id: @note.category.id }).
                          published.where.not(id: @note).order("RANDOM()").first if !@random_note.present?
    @random_note = Note.published.where.not(id: @note).order("RANDOM()").first if !@random_note.present?
    @note.update_attribute "view", @note.view += 1
  end

  def new
    @note = current_user.notes.build
  end

  def create
    params[:note][:body] = params[:note][:body].gsub('source', '<span>source</span>').gsub('position: fixed', '<span>position: fixed</span>').gsub('position:fixed', '<span>position:fixed</span>').gsub('method="delete"', '').gsub('link', '<span>link</span>').gsub('script', '<span>script</span>').gsub("method='delete'", '').gsub(/<iframe .*src="(https?:\/\/)?(?!(?:\/\/www.youtube.com\/embed\/|\/\/player.vimeo.com\/video\/)).*><\/iframe>/, '')
                                .gsub('onerror', '<span>onerror</span>').gsub('onclick', '<span>onclick</span>').gsub('onload', '<span>onload</span>').gsub('onchange', '<span>onchange</span>').gsub('onmouseover', '<span>onmouseover</span>').gsub('onmouseout', '<span>onmouseout</span>').gsub('onmousedown', '<span>onmousedown</span>').gsub('onmouseup', '<span>onmouseup</span>').gsub('onfocus', '<span>onfocus</span>').html_safe
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
    params[:note][:body] = params[:note][:body].gsub('source', '<span>source</span>').gsub('position: fixed', '<span>position: fixed</span>').gsub('position:fixed', '<span>position:fixed</span>').gsub('method="delete"', '').gsub('link', '<span>link</span>').gsub('script', '<span>script</span>').gsub("method='delete'", '').gsub(/<iframe .*src="(https?:\/\/)?(?!(?:\/\/www.youtube.com\/embed\/|\/\/player.vimeo.com\/video\/)).*><\/iframe>/, '')
                                .gsub('onerror', '<span>onerror</span>').gsub('onclick', '<span>onclick</span>').gsub('onload', '<span>onload</span>').gsub('onchange', '<span>onchange</span>').gsub('onmouseover', '<span>onmouseover</span>').gsub('onmouseout', '<span>onmouseout</span>').gsub('onmousedown', '<span>onmousedown</span>').gsub('onmouseup', '<span>onmouseup</span>').gsub('onfocus', '<span>onfocus</span>').html_safe
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

  def import
    Chapter.import(params[:file])
    redirect_to root_url, notice: "Categories Imported."
  end

  private

  def find_note
    @note = Note.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:title, :body, :image, :category, :status, :grade, :grade_id, :category_id, :chapter_id, :tag_list)
  end
end
