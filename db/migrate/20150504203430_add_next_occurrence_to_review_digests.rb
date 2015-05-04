class AddNextOccurrenceToReviewDigests < ActiveRecord::Migration
  def change
    add_column :review_digests, :next_occurrence, :datetime
  end
end
