class User < ActiveRecord::Base
	@client = nil
	@note_store = nil

	def evernote_client
		@client ||= EvernoteOAuth::Client.new(token: self.auth_token,
																				 consumer_key: ENV['EVERNOTE_KEY'],
																				 consumer_secret: ENV['EVERNOTE_SECRET'],
																				 sandbox: ENV['SANDBOX'])
	end

	def note_store
		@note_store ||= evernote_client.note_store
	end
end
