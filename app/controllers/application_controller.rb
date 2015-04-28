class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

	http_basic_authenticate_with name: ENV['USERNAME'], password: ENV['PASSWORD']

	before_filter :get_user

	def index
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
		request_token = OAuth::RequestToken.new @user.evernote_client, session[:token], session[:secret]
		access_token = request_token.get_access_token(oauth_verifier: params[:oauth_verifier])
		@user.update_attribute :access_token, access_token.token
		binding.pry
		redirect '/'
	end

private
	def get_user
		@user = User.first || User.create
	end
end
