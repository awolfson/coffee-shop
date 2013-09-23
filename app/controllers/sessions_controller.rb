class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by_email(params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
  	  sign_in user
  	  redirect_back_or user
  	else
  	  if user && !user.authenticate(params[:session][:password])
  	  	error_message = "Wrong password, please try again."
  	  elsif !user
  	  	error_message = "We can't find a record of that user."
  	  end
  	  flash.now[:error] = error_message
  	  render 'new'
  	end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
