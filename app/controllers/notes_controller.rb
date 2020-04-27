class NotesController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!, except: [:index, :show, :search]
  before_action :find_note, only: [:show, :edit, :update, :destroy, :vote, :verify]

  def index
    if params[:category].present?
      if user_signed_in? and !current_user.teacher?
        @notes = Note.where(:category => params[:category], :grade => current_user.grade).published.paginate(page: params[:page], per_page: 14).order("created_at DESC")
      else
        @notes = Note.where(:category => params[:category]).published.paginate(page: params[:page], per_page: 14).order("created_at DESC")
      end
      @category_title = params[:category].humanize + " Notes"
    else
      if user_signed_in? and !current_user.teacher?
        @notes = Note.where(:grade => current_user.grade).published.paginate(page: params[:page], per_page: 14).order("created_at DESC")
      else
        @notes = Note.published.paginate(page: params[:page], per_page: 14).order("created_at DESC")
      end
      @category_title = "Latest Notes"
    end
  end

  def search
    @query = params[:query]
    @notes = Note.search(@query).published.paginate(page: params[:page], per_page: 7)
    if @notes.present?
      set_meta_tags title: @query, site: 'Mattrab Search', description: @notes.first.body.gsub(/<[^>]*>/, '').truncate(150), keywords: @notes.first.category+" class "+@notes.first.grade,
                    og: { title: @query, description: @notes.first.body.gsub(/<[^>]*>/, '').truncate(150), type: 'website', url: note_url(@notes.first), image: @notes.first.image },
                    twitter: { card: 'note', site: '@askmattrab', title: @query, description: @notes.first.body.gsub(/<[^>]*>/, '').truncate(150), image: @notes.first.image }
    else
      set_meta_tags title: 'No results found', site: 'Mattrab Search'
    end
  end

  def show
    set_meta_tags title: @note.title, site: 'Mattrab', description: @note.body.gsub(/<[^>]*>/, '').truncate(150), keywords: @note.category+" class "+@note.grade,
                  og: { title: @note.title, description: @note.body.gsub(/<[^>]*>/, '').truncate(150), type: 'website', url: note_url(@note), image: @note.image },
                  twitter: { card: 'note', site: '@askmattrab', title: @note.title, description: @note.body.gsub(/<[^>]*>/, '').truncate(150), image: @note.image }
    @questions = Question.where(note_id: @note).order("created_at DESC")
    if user_signed_in?
      @random_note = Note.published.where(category: @note.category, grade: current_user.grade).where.not(id: @note).order("RANDOM()").first
    else
      @random_note = Note.published.where(category: @note.category).where.not(id: @note).order("RANDOM()").first
    end
    if !@random_note.present?
      @random_note = Note.published.where.not(id: @note).order("RANDOM()").first
    end
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
    if @note.pastpapers? or @note.solution?
      @admins = User.where(:role => 'admin')
    else
      @admins = User.where(:admin_category => @note.category)
    end
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
    params.require(:note).permit(:title, :body, :image, :category, :status, :grade)
  end
end
