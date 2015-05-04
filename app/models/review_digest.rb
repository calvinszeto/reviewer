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

  before_save :generate_first_occurrence, if: "previous_occurrence.blank?"

  def generate_first_occurrence
    # Set the first occurrence to today at the requested time
    _, _, time = self.recurrence.split(';')
    self.update_attribute :previous_occurrence, DateTime.strptime(time, TIME_FORMAT)
    self.generate_next_occurrence
  end

  def generate_next_occurrence
    value, unit, _ = self.recurrence.split(';')
    self.update_attribute :next_occurrence, self.previous_occurrence + value.to_i.send(unit)
  end
end
