class CreateDigestion < ActiveRecord::Migration
  def change
    create_table :digestions do |t|
      t.references :review_digest, index: true

      t.timestamps
    end
  end
end
