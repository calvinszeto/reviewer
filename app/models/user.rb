class User < ActiveRecord::Base
	@client = nil
	@note_store = nil
	@notebook = nil

	def evernote_client
		@client ||= EvernoteOAuth::Client.new(token: self.auth_token,
																				 consumer_key: ENV['EVERNOTE_KEY'],
																				 consumer_secret: ENV['EVERNOTE_SECRET'],
																				 sandbox: ENV['SANDBOX'])
	end

	def notebook
		@notebook ||= note_store.listNotebooks.first
	end

	def new_notes
		filter = Evernote::EDAM::NoteStore::NoteFilter.new
		filter.words = "created:day-1"

		spec = Evernote::EDAM::NoteStore::NotesMetadataResultSpec.new
		spec.includeTitle = true
		spec.includeCreated = true
		spec.includeTagGuids = true

		note_store.findNotesMetadata(auth_token, filter, 0, 100, spec).notes
	end

	def note_store
		@note_store ||= evernote_client.note_store
	end
end
