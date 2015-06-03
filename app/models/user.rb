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

require 'time'

class User < ActiveRecord::Base
  has_many :review_digests
  has_many :notes

  @client = nil
  @note_store = nil
  @notebook = nil

  def evernote_client
    @client ||= EvernoteOAuth::Client.new(token: self.auth_token,
                                          consumer_key: ENV['EVERNOTE_KEY'],
                                          consumer_secret: ENV['EVERNOTE_SECRET'],
                                          sandbox: ENV['SANDBOX'] == true)
  end

  def note_store
    @note_store ||= evernote_client.note_store
  end

  def notebook
    @notebook ||= note_store.listNotebooks.first
  end

  def evernote_date_filter
    # Pull notes from since the latest note
    # Or, pull notes from the last week if no notes have ever been pulled
    latest_date = notes.order(created_at: :desc).first.try(:created_at)
    filter = latest_date.nil? ? 'day-7' : latest_date.utc.iso8601.gsub(/:|-/, '')
    "created:#{filter}"
  end

  def process_new_notes
    # Get all reviewable notes since the last one, adds them to the database, and caches them in @new_notes
    filter = Evernote::EDAM::NoteStore::NoteFilter.new
    filter.words = evernote_date_filter

    spec = Evernote::EDAM::NoteStore::NotesMetadataResultSpec.new
    spec.includeTitle = true
    spec.includeCreated = true
    spec.includeTagGuids = true

    notes = note_store.findNotesMetadata(auth_token, filter, 0, 100, spec).notes
    tags = note_store.listTags(auth_token)
    notes.each do |note|
      note_tags = tags.select{|tag| note.tagGuids.include? tag.guid}
      Rails.logger.info "Adding note for user #{user.email}: #{note.title}"
      Note.create evernote_id: note.guid, title: note.title, tags: note_tags.map(&:name)
    end
  end

  def run_passed_review_digests
    process_new_notes
    review_digests.passed.each do |review_digest|
      Rails.logger.info "Running a digestion for Review Digest #{review_digest.id}"
      review_digest.run_digestion
    end
  end
end
