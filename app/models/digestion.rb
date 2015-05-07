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
end
