class Api::V1::NotesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_note, only: [:show, :edit, :update, :destroy]
  
  def index
    @notes = current_user.notes.all
    respond_to do |format|
      format.json { render json: @notes, status: :ok }
    end
  end
  def show
    @note = find_note
    if is_authorized
      respond_to do |format|
        format.json { render json: @note, status: :ok }
      end
    else
      handle_unauthorized
    end
  end
  def create
    @note = current_user.notes.build(note_params)
    @note.title = @note.title.nil? ? "" : @note.title
    @note.body = @note.body.nil? ? "" : @note.body
    respond_to do |format|
      if @note.save
        format.json { render json: @note, status: :created }
      else
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end
  def update
    if is_authorized
      @note.title = @note.title.nil? ? "" : @note.title
      @note.body = @note.body.nil? ? "" : @note.body
      respond_to do |format|
        if @note.update(note_params)
          format.json { render :show, status: :ok, location: api_v1_note_path(@note) }
        else
          format.json { render json: @note.errors, status: :unprocessable_entity }
        end
      end      
    else
      handle_unauthorized
    end
  end
  def destroy
    if is_authorized
      @note.destroy
      respond_to do |format|
        format.json { head :no_content }
      end
    else
      handle_unauthorized
    end
  end

  private
    def find_note
        @note = Note.find(params[:id])
    end
    def is_authorized
        @note.user == current_user
    end
    def note_params
        params.require(:note).permit(:title, :body)
    end

    def handle_unauthorized
      respond_to do |format|
        format.json { render json: {error: "Unauthorized"}, status: :unauthorized}
      end
    end
end
