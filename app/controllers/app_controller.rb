class AppController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :authorize_request, except: :create_user

	def create_user
		begin
			@user = User.create(name: params[:name], email: params[:email], password: params[:password])
			token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i
      render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
	                     username: @user&.name }, status: :ok
		rescue
			render json: {error: "something went wrong"}, status: 302
		end
	end

	def get_posts
		capacity = params[:threshold] || 20
		user_posts = Post.order(id: :desc).first(capacity)
		if user_posts
			data = []
			user_posts.each do |post|
				post_data = {}
				post_data[:id] = post.id
				post_data[:thumbnail_url] =  post&.thumbnail
				post_data[:category] = post&.category
				post_data[:description] = post&.description
				post_data[:auther_name] = post&.user&.name
				post_data[:Comments_count] = post&.comments&.count rescue 0
				data << post_data
			end
			render json: {data: data}, status: 200
		else
			render json: { notice: "No Post available" }
		end
	end

	def create_post
		# binding.pry
		post = Post.new
		post.description = params['description']
		post.thumbnail = params['image_url']
		post.category = params['category'] 
		post.user_id = @current_user.id
		if post.save
			render json: {sucess: "post created sucessfully"}, status: 200
		else
			render json: {error: "something went wrong"}, status: 502
		end
	end

	def edit_post
		# Rails.logger.info"********params:#{params}***********"
		# binding.pry
		post = Post.where(user_id: @current_user.id, id: params[:id]).last
		if post
			begin
				data = {}
				data["description"] = params['description'] if params['description'].present?
				data["thumbnail"] = params['image_url'] if params['image_url'].present?
				data["category"] = params['category'] if params['category'].present?
		    post.update_columns(data)
		    render json: {sucess: "post edited"}, status: 200
		  rescue
		  	render json: {error: "something went wrong"}, status: 502
		  end
		else
			render json: {error: "access denied"}, status: 302
		end
	end

	def get_comments
		comments = Comment.where(post_id: params[:post_id]).order(id: :desc)
		if comments
			data = []
			comments.each do |comment|
				comment_data = {}
				comment_data["commented_user_id"] = comment.user_id
				comment_data["commented_user_name"] = comment.user.name
				comment_data["post_id"] = comment.post_id
				comment_data["discription"] = comment.discription
				data << comment_data
			end
			render json: {data: data}, status: 200
		else
			render json: {error: "no comments available"}, status: 200
		end
	end


	def add_comment
		comment = Comment.new
		comment.user_id = params[:user_id]
		comment.post_id = params[:post_id]
		comment.discription = params[:discription]
		if comment
			render json: {sucess: "comment created sucessfully"}, status: 200
		else
			render json: {error: "something went wrong"}, status: 502
		end
	end


end
