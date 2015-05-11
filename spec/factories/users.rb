# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  auth_token :string(255)
#  created_at :datetime
#  updated_at :datetime
#  email      :string(255)
#

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user-#{n}@reviewer.com" }
  end
end
