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

class Digestion < ActiveRecord::Base
  belongs_to :review_digest
  has_many :notes_digestions
  has_many :notes, through: :notes_digestions

  def execute
    notes_cache = self.notes
    notes_cache.each {|note| note.collect_content }
    DigestionMailer.digestion_email(self, notes_cache).deliver
  end
end
