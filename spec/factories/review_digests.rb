# == Schema Information
#
# Table name: review_digests
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  tags                :text             default([]), is an Array
#  recurrence          :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  user_id             :integer
#  next_occurrence     :datetime
#  previous_occurrence :datetime
#

FactoryGirl.define do
  factory :review_digest do
    sequence(:name) {|n| "review digest #{n}"}
    tags { %w(math science history french computers).take(3)}
    recurrence {"1;day;08:00-0400"}
    user
  end
end
