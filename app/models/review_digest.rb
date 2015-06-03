# == Schema Information
#
# Table name: review_digests
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  tags                :text             default([]), is an Array
#  recurrence          :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  user_id             :integer
#  next_occurrence     :datetime
#  previous_occurrence :datetime
#

class ReviewDigest < ActiveRecord::Base
  # Recurrence is formatted as such: "VALUE;UNIT;TIME"
  # For example, a daily digest at 12PM - "1;day;12:00"
  # All datetimes are stored in UTC and converted to the User's preferred timezone in the frontend
  TIME_FORMAT = "%H:%M"

  belongs_to :user
  has_many :digestions

  before_save :generate_first_occurrence, if: "next_occurrence.blank?"

  scope :passed, -> { where('next_occurrence < ?', DateTime.now) }

  def generate_first_occurrence
    # Set the first occurrence to today at the requested time
    _, _, time = self.recurrence.split(';')
    self.update_attribute :next_occurrence, DateTime.strptime(time, TIME_FORMAT) + 1.day
  end

  def generate_next_occurrence
    former_occurrence = self.next_occurrence
    value, unit, _ = self.recurrence.split(';')
    self.update_attribute :next_occurrence, former_occurrence + value.to_i.send(unit)
    self.update_attribute :previous_occurrence, former_occurrence
  end

  def run_digestion
    notes = Note.for_digest(self)
    unless notes.empty?
      digestion = Digestion.create(review_digest: self, email: user.email)
      Note.for_digest(self).each { |note| NotesDigestion.create(note: note, digestion: digestion) }
      digestion.execute
      Rails.logger.info "Ran a digestion for #{notes.count} notes."
    else
      Rails.logger.info "No notes to review for this occurrence."
    end
    generate_next_occurrence
  end
end
