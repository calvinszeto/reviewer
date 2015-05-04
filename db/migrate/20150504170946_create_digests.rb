class CreateDigests < ActiveRecord::Migration
  def change
    create_table :digests do |t|
      t.string :name
      t.text :tags, array: true, default: []
      t.string :recurrence

      t.timestamps
    end
  end
end
