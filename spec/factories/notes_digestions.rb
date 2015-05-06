# == Schema Information
#
# Table name: notes_digestions
#
#  id           :integer          not null, primary key
#  note_id      :integer
#  digestion_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

FactoryGirl.define do
  factory :notes_digestion do
    note
    digestion
  end
end
