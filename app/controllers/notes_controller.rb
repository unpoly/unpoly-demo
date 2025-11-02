class NotesController < ApplicationController

  def new
    build_note
  end

  def create
    build_note
    save_note(form: 'new')
  end

  def edit
    load_note
    build_note
  end

  def update
    load_note
    build_note
    save_note(form: 'edit')
  end

  def show
    load_note
  end

  def index
    load_notes
  end

  def destroy
    load_note
    if @note.destroy
      up.layer.emit('note:destroyed')
      redirect_to notes_path
    else
      redirect_to @note, alert: 'Could not delete note'
    end
  end

  private

  def build_note
    @note ||= note_scope.build
    @note.attributes = note_attributes
  end

  def load_note
    @note ||= note_scope.find(params[:id])
  end

  def save_note(form:)
    if up.validate?
      @note.valid? # run validations
      render form
    elsif @note.save
      up.layer.emit('note:saved')
      redirect_to @note, notice: 'Note saved successfully'
    else
      render form, status: :bad_request
    end
  end

  def load_notes
    @notes = note_scope.order(:name).to_a
  end

  def note_scope
    current_tenant.notes
  end

  def note_attributes
    if (attrs = params[:note])
      attrs.permit(:title, :body)
    else
      {}
    end
  end

end
