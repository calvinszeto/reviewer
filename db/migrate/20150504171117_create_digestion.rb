class CreateDigestion < ActiveRecord::Migration
  def change
    create_table :digestions do |t|
      t.references :digest, index: true

      t.timestamps
    end
  end
end
