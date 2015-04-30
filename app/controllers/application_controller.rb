class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

	http_basic_authenticate_with name: ENV['USERNAME'], password: ENV['PASSWORD']

	before_filter :get_user

	def index
		@notebook = @user.evernote_client.note_store.listNotebooks.first
		filter = Evernote::EDAM::NoteStore::NoteFilter.new
		filter.words = "created:day-1"

		spec = Evernote::EDAM::NoteStore::NotesMetadataResultSpec.new
		spec.includeTitle = true
		spec.includeCreated = true
		spec.includeTagGuids = true

		@notes = @user.note_store.findNotesMetadata(@user.auth_token, filter, 0, 100, spec).notes
	end

	def authorize
		callback_url = "#{root_url}callback"
		request_token = @user.evernote_client.request_token(oauth_callback: callback_url)
		session[:token] = request_token.token
		session[:secret] = request_token.secret
		redirect_to request_token.authorize_url
	end

	def callback
		unless params[:oauth_verifier]
			redirect_to '/authorize'
		end
		access_token = @user.evernote_client.authorize session[:token], session[:secret], {oauth_verifier: params[:oauth_verifier]}
		@user.update_attribute :auth_token, access_token.token
		redirect_to '/'
	end

private
	def get_user
		@user = User.first || User.create
	end
end
