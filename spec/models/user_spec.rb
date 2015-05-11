# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  auth_token :string(255)
#  created_at :datetime
#  updated_at :datetime
#  email      :string(255)
#

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:evernote_client) { double }
  let(:note_store) { double }
  let(:note_filter) { double }
  let(:note_metadata_spec) { double }
  let(:note) { double }
  let(:tag) { double }

  before(:each) do
    allow(EvernoteOAuth::Client).to receive(:new) { evernote_client }
    allow(evernote_client).to receive(:note_store) { note_store }

    allow(Evernote::EDAM::NoteStore::NoteFilter).to receive(:new) { note_filter }
    allow(Evernote::EDAM::NoteStore::NotesMetadataResultSpec).to receive(:new) { note_metadata_spec }

    response = double
    allow(note_store).to receive(:findNotesMetadata) { response }
    allow(response).to receive(:notes) { [note]}
    allow(note_store).to receive(:listTags) { [tag] }

    allow(note).to receive(:tagGuids) { ["111"] }
    allow(note).to receive(:guid) { "12345" }
    allow(note).to receive(:title) { "My Note" }

    allow(tag).to receive(:guid) { "111" }
    allow(tag).to receive(:name) { "My Tag" }
  end

  context 'evernote_date_filter' do
    it 'should return a filter to pull from last 7 days if no notes have yet been pulled' do
      expect(user.evernote_date_filter).to eq('created:day-7')
    end

    it 'should return a filter to pull since the latest note' do
      created_at = DateTime.new(2015,4,5,6,7,8,'-4')
      FactoryGirl.create(:note, created_at: created_at, user: user)
      expect(user.evernote_date_filter).to eq('created:20150405T100708Z')
    end
  end

  context 'process_new_notes' do
    before(:each) do
      allow_any_instance_of(User).to receive(:evernote_date_filter) { "created:DATE"}
      allow(note_filter).to receive(:words=)
      allow(note_metadata_spec).to receive(:includeTitle=)
      allow(note_metadata_spec).to receive(:includeCreated=)
      allow(note_metadata_spec).to receive(:includeTagGuids=)
    end

    it 'should set the filter to the evernote_date_filter' do
      expect(note_filter).to receive(:words=).with("created:DATE")
      user.process_new_notes
    end

    it 'should include the title, created date, and tags' do
      expect(note_metadata_spec).to receive(:includeTitle=).with(true)
      expect(note_metadata_spec).to receive(:includeCreated=).with(true)
      expect(note_metadata_spec).to receive(:includeTagGuids=).with(true)
      user.process_new_notes
    end

    it 'should create a note for each note' do
      expect{
        user.process_new_notes
      }.to change{Note.count}.from(0).to(1)
      expect(Note.first.evernote_id).to eq("12345")
      expect(Note.first.title).to eq("My Note")
    end

    it 'should replace the note tag guids with tag names' do
      user.process_new_notes
      expect(Note.first.tags).to eq(["My Tag"])
    end
  end
end