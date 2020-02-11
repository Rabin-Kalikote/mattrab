class NotesController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!, except: [:index, :show, :search]
  before_action :find_note, only: [:show, :edit, :update, :destroy, :vote, :verify]

  def index
    if params[:category].present?
      @notes = Note.where(:category => params[:category]).published.paginate(page: params[:page], per_page: 8).order("created_at DESC")
      @category_title = params[:category].humanize + " Notes"
    else
      @notes = Note.published.paginate(page: params[:page], per_page: 8).order("created_at DESC")
      @category_title = "Latest Notes"
    end
  end

  def search
    @query = params[:query]
    @notes = Note.search(@query).published.paginate(page: params[:page], per_page: 5)
  end

  def show
    @questions = Question.where(note_id: @note).order("created_at DESC")
    @random_note = Note.published.where.not(id: @note).order("RANDOM()").first
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

  private

  def find_note
    @note = Note.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:title, :body, :image, :category, :status)
  end
end
