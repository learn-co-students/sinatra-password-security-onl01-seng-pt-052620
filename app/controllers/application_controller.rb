require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

	configure do
		set :views, "app/views"
		enable :sessions
		set :session_secret, "password_security"
	end

	#Renders an index.erb file with links to signup or login 
	get "/" do
		erb :index
	end

	#Renders a form to create a new user 
	get "/signup" do
		erb :signup
	end

	post "/signup" do
		user = User.new(:username => params[:username], :password => params[:password])

		if user.save  #Will return false if the user can't be persisted. No password. 
			redirect "login" 
		else 
			redirect "failure" 
		end 
	end

	#Renders a form for logging in 
	get "/login" do
		erb :login
	end

	post "/login" do
		user = User.find_by(username: params[:username])
		if user && user.authenticate(params[:password])
			session[:user_id] = user.id 
			redirect "/success"
		else 
			redirect "/failure" 
		end 
	end


	#Renders a success.erb page if a user successfully logs in 
	get "/success" do
		if logged_in?
			erb :success
		else
			redirect "/login"
		end
	end


	#Renders a failure.erb page upon error logging in or signing up 
	get "/failure" do
		erb :failure
	end


	#clears the session and redirects to home page. 
	get "/logout" do
		session.clear
		redirect "/"
	end



	helpers do
		def logged_in?
			!!session[:user_id]
		end

		def current_user
			User.find(session[:user_id])
		end
	end

end
