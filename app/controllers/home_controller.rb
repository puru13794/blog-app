class HomeController < ApplicationController
	def index
		# Rails.logger.info"********token#{Rails.application.secrets.jwt_token}"
		if user_signed_in?
			@posts = Post.all
		else
			redirect_to new_user_session_path
		end
	end
end
