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

require 'rails_helper'

RSpec.describe ReviewDigest, type: :model do
  context "passed scope" do
    it "should return ReviewDigests whose next occurrence time has passed" do
      passed_digest = FactoryGirl.create :review_digest
      future_digest = FactoryGirl.create :review_digest
      passed_digest.update_attribute :next_occurrence, DateTime.now - 1.minute
      future_digest.update_attribute :next_occurrence, DateTime.now + 1.day
      expect(ReviewDigest.passed).to eq([passed_digest])
    end
  end

  context "generate_first_occurence" do
    it "should set the first next occurence as tomorrow at the requested time" do
      time = DateTime.now + 1.day
      recurrence = "1;day;#{time.strftime(ReviewDigest::TIME_FORMAT)}"
      digest = FactoryGirl.create :review_digest, recurrence: recurrence
      expect(digest.next_occurrence.to_s(:long)).to eq(time.to_s(:long))
    end
  end

  context "generate_next_occurrence" do
    it "should calculate the next occurrence by adding the requested value to the previous occurrence" do
      time = DateTime.now + 1.day
      next_time = time + 5.weeks
      recurrence = "5;week;#{time.strftime(ReviewDigest::TIME_FORMAT)}"
      digest = FactoryGirl.create :review_digest, recurrence: recurrence
      expect {
        digest.generate_next_occurrence
      }.to change{digest.next_occurrence.to_s(:long)}.from(time.to_s(:long)).to(next_time.to_s(:long))
    end

    it "should set previous occurrence to the value of the former next occurrence" do
      time = DateTime.now + 1.day
      recurrence = "5;week;#{time.strftime(ReviewDigest::TIME_FORMAT)}"
      digest = FactoryGirl.create :review_digest, recurrence: recurrence
      expect {
        digest.generate_next_occurrence
      }.to change{digest.previous_occurrence.try(:to_s, :long)}.from(nil).to(time.to_s(:long))
    end
  end
end
