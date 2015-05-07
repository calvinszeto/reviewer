# == Schema Information
#
# Table name: digestions
#
#  id               :integer          not null, primary key
#  review_digest_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#  email            :string(255)
#

FactoryGirl.define do
  factory :digestion do
    review_digest
  end
end
