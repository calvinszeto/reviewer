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

class NotesDigestion < ActiveRecord::Base
  belongs_to :note
  belongs_to :digestion
end
