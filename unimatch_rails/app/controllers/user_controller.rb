class UserController < ApplicationController
  def list
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def user_param
   params.require(:user).permit(:email, :name, :surname, :password)
  end
  
  def create
    @user = User.new(user_param)
    if @user.save
      flash[:notice] = "success"
      flash[:color] = "valid"
    else
      flash[:notice] = "error"
      flash[:color] = "invalid"
    end
    
    render "new"
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    
    if @user.update_attributes(user_param)
      redirect_to :action => 'list'
    end
  end
  
  def delete
    User.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end

