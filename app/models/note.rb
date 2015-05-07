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

class Note < ActiveRecord::Base
  belongs_to :user
  has_many :notes_digestions
  has_many :digestions, through: :notes_digestions

  def self.for_digest(digest)
    digest_tags_sql = "{#{digest.tags.map{|tag| "\"#{tag}\""}.join(", ")}}"
    self.where("tags && ?", digest_tags_sql)
  end

  def day_of_next_review
    n = digestions.count + 1
    last_digestion = digestions.order(created_at: :desc).first
    (last_digestion.created_at + nth_lucas_number(n).days).to_date
  end

  def nth_lucas_number(n)
    seed = [2, 1]
    (n-1).times do
      current, last = seed.last(2)
      seed << current + last
    end
    seed.last
  end
end
