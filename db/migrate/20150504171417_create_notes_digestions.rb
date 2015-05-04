class CreateNotesDigestions < ActiveRecord::Migration
  def change
    create_table :notes_digestions do |t|
      t.references :note, index: true
      t.references :digestion, index: true

      t.timestamps
    end
  end
end
