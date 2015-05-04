# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  auth_token :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  has_many :review_digests
  has_many :notes

  @client = nil
  @note_store = nil
  @notebook = nil
  @new_notes = nil

  def evernote_client
    @client ||= EvernoteOAuth::Client.new(token: self.auth_token,
                                          consumer_key: ENV['EVERNOTE_KEY'],
                                          consumer_secret: ENV['EVERNOTE_SECRET'],
                                          sandbox: ENV['SANDBOX'])
  end

  def notebook
    @notebook ||= note_store.listNotebooks.first
  end

  def process_new_notes
    # Get all reviewable notes from the past day, adds them to the database, and caches them in @new_notes
    filter = Evernote::EDAM::NoteStore::NoteFilter.new
    filter.words = "created:day-1"

    spec = Evernote::EDAM::NoteStore::NotesMetadataResultSpec.new
    spec.includeTitle = true
    spec.includeCreated = true
    spec.includeTagGuids = true

    notes = note_store.findNotesMetadata(auth_token, filter, 0, 100, spec).notes
    @new_notes = notes
  end

  def notes_for_digest(digest)

  end

  def note_store
    @note_store ||= evernote_client.note_store
  end
end
