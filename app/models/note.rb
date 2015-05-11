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

class Note < ActiveRecord::Base
  belongs_to :user
  has_many :notes_digestions
  has_many :digestions, through: :notes_digestions

  validates :evernote_id, uniqueness: true

  attr_accessor :content

  def self.for_digest(digest)
    digest_tags_sql = "{#{digest.tags.map{|tag| "\"#{tag}\""}.join(", ")}}"
    # Notes which match the tags of the digest
    digest_notes = self.where("tags && ?", digest_tags_sql)
    # Of those notes, notes whose day of next review occurs on or before the digests next planned digestion
    digest_notes.select {|note| note.day_of_next_review <= digest.next_occurrence.to_date}
  end

  def collect_content
    evernote = user.note_store.getNote(user.auth_token, self.evernote_id, true, false, false, false)
    self.content = evernote.content
  end

  def day_of_next_review
    n = digestions.count + 1
    last_digestion = digestions.order(created_at: :desc).first
    last_digestion.present? ? (last_digestion.created_at + nth_lucas_number(n).days).to_date : Date.today
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
