# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  auth_token :string(255)
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :user do
  end
end
