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

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end
