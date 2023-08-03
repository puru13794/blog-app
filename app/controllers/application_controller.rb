class ApplicationController < ActionController::Base
	def authenticate_user
	    unless user_signed_in?
	      if request.xhr?
	        if request.format.js?
	          # Respond to Ajax JS request
	          render js: "window.location = '#{root_path}'"
	        elsif request.format.json?
	          # Respond to Ajax JSON request
	          render json: {:error => "authenticate_error", :redirect_location_path => root_path}
	        else
	          # Any other...
	          render js: "window.location = '#{root_path}'"
	        end
	      else
	        redirect_to root_path and return # Respond to normal request
	      end
	    end
	end
end
