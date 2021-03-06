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

require 'rails_helper'

RSpec.describe Note, type: :model do
  context 'Note.for_digest' do
    let!(:expected_note) { FactoryGirl.create(:note) }
    let!(:unexpected_note) { FactoryGirl.create(:note) }
    let!(:review_digest) { FactoryGirl.create(:review_digest) }

    it 'should return notes which share tags with the digest' do
      unexpected_note.update_attribute :tags, ["burgers"]
      expect(Note.for_digest(review_digest)).to eq([expected_note])
    end

    it 'should return notes whose next review occurs on or before the current date' do
      # There should be a 3 day review
      digestion = FactoryGirl.create(:notes_digestion, note: expected_note).digestion
      digestion.update_attribute :created_at, DateTime.now - 3.days
      # The next review isn't for 4 days
      2.times do
        digestion = FactoryGirl.create(:notes_digestion, note: unexpected_note).digestion
        digestion.update_attribute :created_at, DateTime.now - 3.days
      end
      expect(Note.for_digest(review_digest)).to eq([expected_note])
    end
  end

  context 'collect_content' do
    let(:user) { FactoryGirl.create(:user) }
    let(:note) { FactoryGirl.create(:note, user: user) }

    before(:each) do
      note_store = double
      evernote_note = double
      allow_any_instance_of(User).to receive(:note_store) { note_store }
      allow(note_store).to receive(:getNote) { evernote_note }
      allow(evernote_note).to receive(:content) { "<en-note>My Note Content</en-note>" }
    end

    it 'should make a request for the note content and attach it to the object' do
      expect{
        note.collect_content
      }.to change{note.content}.from(nil).to("<div>My Note Content</div>")
    end
  end

  context 'parse_enml' do
    let(:enml) do
      '<?xml version="1.0" encoding="UTF-8"?>'+
      '<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">'+
      '<en-note><div>Here is some test data:<br clear="none"/></div>'+
      '<ul><li>testing<br clear="none"/></li><li>testing 2'+
      '<br clear="none"/></li></ul><div><span>我</span><span>看不到</span><span>你</span></div></en-note>'
    end

    let(:html) do
      '<div><div>Here is some test data:<br clear="none"></div>'+
      '<ul><li>testing<br clear="none"></li><li>testing 2'+
      '<br clear="none"></li></ul><div><span>我</span><span>看不到</span><span>你</span></div></div>'
    end

    it 'should move the content into a div' do
      expect(Note.parse_enml(enml).gsub(/\n/, '')).to eq(html)
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
