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

require 'rails_helper'

RSpec.describe Note, type: :model do
  context 'Note.for_digest' do
    let(:expected_note) { FactoryGirl.create(:note) }
    let(:unexpected_note) { FactoryGirl.create(:note, tags: ["burgers"]) }
    let(:review_digest) { FactoryGirl.create(:review_digest) }

    it 'should return notes which share tags with the digest' do
      expect(Note.for_digest(review_digest)).to eq([expected_note])
    end
  end

  context 'nth_lucas_number' do
    let(:note) { FactoryGirl.build(:note) }

    it 'should return 1 for 1' do
      expect(note.nth_lucas_number(1)).to eq(1)
    end

    it 'should return 4 for 3' do
      expect(note.nth_lucas_number(3)).to eq(4)
    end

    it 'should return 76 for 9' do
      expect(note.nth_lucas_number(9)).to eq(76)
    end
  end

  context "day_of_next_review" do
    let(:note) { FactoryGirl.create(:note) }

    it "should return the next day to review based on past reviews" do
      digestion = nil
      3.times do
        digestion = FactoryGirl.create(:notes_digestion, note: note).digestion
      end
      expected_date = (digestion.created_at + 7.days).to_date
      expect(note.day_of_next_review).to eq(expected_date)
    end
  end
end
