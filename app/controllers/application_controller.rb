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
		session[:authorize_url] = @user.evernote_client.request_token(
			oauth_callback: callback_url
	  ).authorize_url
		redirect_to '/authorize'
	end

	def authorize
		if session[:authorize_url]
			redirect_to session[:authorize_url]
		else
			redirect_to '/request_token'
		end
	end

	def callback 
		unless params[:oauth_verifier] || session[:authorize_url]
			redirect_to '/request_token'
		end
		session[:access_token] = session[:request_token].get_access_token(:oauth_verifier => session[:oauth_verifier])
		redirect '/list'
	end

private

	def get_user
		@user = User.first || User.create
	end
end
