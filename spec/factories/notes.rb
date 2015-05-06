# == Schema Information
#
# Table name: notes
#
#  id              :integer          not null, primary key
#  evernote_id     :integer
#  tags            :text             default([]), is an Array
#  note_created_at :datetime
#  created_at      :datetime
#  updated_at      :datetime
#  user_id         :integer
#

FactoryGirl.define do
  factory :note do
    tags %w(math science)
  end
end
