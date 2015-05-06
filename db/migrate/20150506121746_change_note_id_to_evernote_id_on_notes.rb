class ChangeNoteIdToEvernoteIdOnNotes < ActiveRecord::Migration
  def change
    rename_column :notes, :note_id, :evernote_id
  end
end
