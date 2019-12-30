class NotesController < ApplicationController
  # load_and_authorize_resource
  before_action :find_note, only: [:show, :edit, :update, :destroy, :upvote, :downvote]
  before_action :authenticate_user!, except: [:index, :show, :search]

  def index
    if params[:category].present?
      @notes = Note.where(:category => params[:category]).order("created_at DESC")
    else
      @notes = Note.all.order("created_at DESC")
    end
  end

  def search
    #@notes = Note.where("title LIKE ?", "%" + params[:query] + "%")
    @notes = Note.search(params[:query]) || []
  end

  def show
    @comments = Comment.where(note_id: @note).order("created_at DESC")
    @random_note = Note.where.not(id: @note).order("RANDOM()").first
    @note.update_attribute "view", @note.view += 1
  end

  def new
    @note = current_user.notes.build
  end

  def create
    @note = current_user.notes.build(note_params)

    if @note.save
      redirect_to @note
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

  def upvote
    @note.upvote_by current_user
    redirect_back fallback_location: @note
  end

  def downvote
    @note.downvote_by current_user
    redirect_back fallback_location: @note
  end

  private

  def find_note
    @note = Note.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:title, :body, :image, :category)
  end
end
