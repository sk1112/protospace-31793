class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @prototype = @user.prototype
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      redirect_to user_path(current_user)
    else
      @user = User.find(params[:id])
      render action: :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :profile, :occupation, :position).merge(id: current_user.id)
  end
end