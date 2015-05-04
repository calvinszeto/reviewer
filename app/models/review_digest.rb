# == Schema Information
#
# Table name: review_digests
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  tags       :text             default([]), is an Array
#  recurrence :string(255)
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#

class ReviewDigest < ActiveRecord::Base
  belongs_to :user
  has_many :digestions
end
