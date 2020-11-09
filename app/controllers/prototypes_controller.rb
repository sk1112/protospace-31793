class PrototypesController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :destroy]
  before_action :set_prototype, only: [:show, :edit]
  before_action :move_to_index, except: [:index, :show]

  def index
    @prototypes = Prototype.includes(:user).order("created_at DESC")
  end

  def new
    @prototype = Prototype.new
  end

  def create
    prototype = Prototype.create(prototype_params)
    if prototype.save
      redirect_to root_path
    else
      @prototype = Prototype.new
      render action: :new
    end
  end
  
  def show
    @comment = Comment.new
    @comments = @prototype.comment.includes(:user)
  end

  def edit
    unless user_signed_in? && current_user.id == @prototype.user.id
      redirect_to action: :index
    end
  end

  def update
    prototype = Prototype.find(params[:id])
    if prototype.update(prototype_params)
      redirect_to prototype_path
    else
      @prototype = Prototype.find(params[:id])
      render action: :edit
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    if prototype.destroy
      redirect_to root_path
    else
      @comment = Comment.new
      @comments = @prototype.comment.includes(:user)
      render action: :show
    end
  end

  private
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end

  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end
  end
end