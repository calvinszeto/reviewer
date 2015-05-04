class CreateReviewDigests < ActiveRecord::Migration
  def change
    create_table :review_digests do |t|
      t.string :name
      t.text :tags, array: true, default: []
      t.string :recurrence

      t.timestamps
    end
  end
end
