class AppController < ApplicationController
	before_action :authorize_request

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


end
