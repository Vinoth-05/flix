class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_signin, except: [:new, :create]
  before_action :require_current_user, only: [:edit, :update, :destroy]
  
  def require_signin
    if !current_user
      session[:intended_url] = request.url
      redirect_to signin_path
    end
  end

  def require_current_user
    @user = User.find(params[:id])
    redirect_to @user, alert: "You can't do this action." unless @user == current_user
  end

  def index
    @users = User.not_admin
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = 'User Account created successfully'
      redirect_to user_path(@user)
    else
      render :new
    end
  end
  
  def show
    
  end

  def edit
    
  end

  def update
    if @user.update(user_params)
      flash[:success] = 'User Account updated successfully'
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    flash[:alert] = 'User account removed'
    redirect_to signout_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :username, :email, :password, :password_confirmation)
  end

end
