class LikesController < ApplicationController
  before_action :require_signin

  def require_signin
    if !current_user
      session[:intended_url] = request.url
      redirect_to signin_path, notice:"You are not signed in!!! Please signIn to continue"
    end
  end

  def create
    @movie = Movie.find_by(slug: params[:movie_id])
    @movie.likes.new(user: current_user)
    @movie.save
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find_by(slug: params[:movie_id])
    @like = Like.find_by(movie: @movie, user: current_user)
    @like.destroy
    redirect_to movie_path(@movie)
  end
end
