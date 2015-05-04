class AddUserIdToReviewDigests < ActiveRecord::Migration
  def change
    add_reference :review_digests, :user, index: true
  end
end
