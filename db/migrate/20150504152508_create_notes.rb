class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :note_id
      t.text :tags, array: true, default: []
      t.datetime :note_created_at
    end
  end
end
