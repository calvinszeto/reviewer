# == Schema Information
#
# Table name: notes
#
#  id              :integer          not null, primary key
#  tags            :text             default([]), is an Array
#  note_created_at :datetime
#  created_at      :datetime
#  updated_at      :datetime
#  user_id         :integer
#  title           :string(255)
#  evernote_id     :string(255)
#

FactoryGirl.define do
  factory :note do
    tags %w(math science)
    evernote_id { (Random.rand * 100000).to_i }
  end
end
