class AddPreviousOccurrenceToReviewDigest < ActiveRecord::Migration
  def change
    add_column :review_digests, :previous_occurrence, :datetime
  end
end
