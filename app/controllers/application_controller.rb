class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

	http_basic_authenticate_with name: ENV['USERNAME'], password: ENV['PASSWORD']

	before_filter :get_user

	def index
	end

	def request_token
		callback_url = "#{root_url}callback"
		session[:request_token] = @user.evernote_client.request_token(
			oauth_callback: callback_url
	  )
		redirect_to '/authorize'
	end

	def authorize
		binding.pry
		if session[:request_token]
			redirect_to session[:request_token].authorize_url
		else
			render nothing: true
		end
	end

	def callback
	end

	private

	def get_user
		@user = User.first || User.create
	end
end
