class ChangeEvernoteIdToString < ActiveRecord::Migration
  def up
    remove_column :notes, :evernote_id
    add_column :notes, :evernote_id, :string
  end

  def down
    remove_column :notes, :evernote_id
    add_column :notes, :evernote_id, :integer
  end
end
