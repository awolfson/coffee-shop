class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end
  
  def new
  	@user = User.new
  end

  def create
  	@user = User.new(name: params[:name], 
                    email: params[:email], 
                    password: params[:password], 
                    password_confirmation: params[:password_confirmation])
  	if @user.save
      sign_in @user
  		flash[:success] = "Welcome to CoffeeShop!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end
end
