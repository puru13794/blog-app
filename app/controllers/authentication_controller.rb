class AuthenticationController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authorize_request, except: :login

  # POST /auth/login
  def login
  	begin
	    @user = User.find_by_email(params[:email])
	    if @user&.valid_password?(params[:password])
	      token = JsonWebToken.encode(user_id: @user.id)
	      time = Time.now + 24.hours.to_i
	      render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
	                     username: @user&.name }, status: :ok
	    else
	      render json: { error: 'unauthorized' }, status: :unauthorized
	    end
		rescue
			render json: { error: 'something went wrong' }, status: :unauthorized
		end
  end

  private

  def login_params
    params.permit(:email, :password)
  end
end
