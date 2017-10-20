class SessionsController < ApplicationController
  def new
  end
  
  def create
    @user = User.find_by_name params[:user][:name]
    if @user
      session[:user_id] = @user.id
      redirect_to root_path
    else
      @error = 'User not found'
      render 'new'
    end
  end

  def destroy
  end
end
