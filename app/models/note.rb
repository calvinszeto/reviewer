# == Schema Information
#
# Table name: notes
#
#  id              :integer          not null, primary key
#  note_id         :integer
#  tags            :text             default([]), is an Array
#  note_created_at :datetime
#  created_at      :datetime
#  updated_at      :datetime
#  user_id         :integer
#

class Note < ActiveRecord::Base
  belongs_to :user
  has_many :notes_digestions
  has_many :digestions, through: :notes_digestions
end
