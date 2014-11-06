class PostsController < ApplicationController

  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def new
    @post = Post.new
    authorize! :manage, @post
  end

  def index
    @posts = Post.all.paginate(:page => params[:page], :per_page => 5)
  end

  def create
    post = Post.new(post_params)
    post.user_id = current_user.id
    if post.save
      redirect_to posts_path, notice: 'Пост создан'
    else
      render :edit, notice: 'Ошибка'
    end
    authorize! :manage, @post
  end

  def destroy
    if @post.destroy
      redirect_to posts_path, notice: 'Пост удален'
    else
      redirect_to posts_path, notice: 'Ошибка при удалении'
    end
    authorize! :manage, @post
  end

  def update
    if @post.update_attributes(post_params)
      redirect_to posts_path, notice: 'Пост изменен'
    else
      render :edit, notice: 'Ошибка'
    end
    authorize! :manage, @post
  end

  def edit
    authorize! :manage, @post
  end

  private

  def post_params
    params[:post].permit(:title, :text, :champ_id)
  end

  def set_post
    @post = Post.find(params[:id])
  end

end
