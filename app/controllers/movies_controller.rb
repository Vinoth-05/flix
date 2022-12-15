class MoviesController < ApplicationController
  before_action :set_movie, only: [:show, :edit, :update, :destroy]
  before_action :require_admin, only: [:new, :show, :create, :edit, :update, :destroy]

  def index
    type = params["type"]
    case type
    when "released"
      @movies = Movie.released
    when "upcoming"
      @movies = Movie.upcoming
    when "recent"
      @movies = Movie.recent
    when 'hit'
      @movies = Movie.all_hit_movies
    when 'flop'
      @movies = Movie.all_flop_movies
    else
      @movies = Movie.all
    end
    # @movies = Movie.all_hit_movies
    # @movies = Movie.all_flop_movies
    # @movies = Movie.recently_added
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      flash[:success] = 'Movie created successfully'
      redirect_to @movie
    else
      render :new
    end
  end
  
  def show
  end
  
  def edit
  end
  
  def update
    if @movie.update(movie_params)
      flash[:success] = 'Movie updated successfully'
      redirect_to @movie
    else
      flash[:notice] = 'Error! Movie update failed'
      render :edit
    end
  end
  
  def destroy
    @movie.destroy
    flash[:alert] = 'Movie deleted successfully'
    redirect_to movies_path
  end

  private

  def movie_params
    movie_params = params.require(:movie).permit(:title, :rating, :total_gross, :description, :released_on, :director, :duration, :main_image, genre_ids: [])
  end

  def set_movie
    @movie = Movie.find_by(slug: params[:id])
  end

end
