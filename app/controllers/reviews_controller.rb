class ReviewsController < ApplicationController
  before_action :set_movie, only: [:index, :new, :create]
  before_action :set_review, only: [:edit, :update, :destroy]
  before_action :require_signin

  def require_signin
    if !current_user
      session[:intended_url] = request.url
      redirect_to signin_path, notice:"You are not signed in!!! Please signIn to continue"
    end
  end

  def index
    @reviews = @movie.reviews
  end

  def new
    @review = @movie.reviews.new
  end
  
  def create
    @review = @movie.reviews.new(review_params)
    @review.user = current_user
    if @review.save
      flash[:success] = 'Review created successfully'
      redirect_to movie_reviews_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @review.update(review_params)
      # Review.delay(queue: "tracking", priority: 1, run_at: 2.seconds.from_now).bg_job("Venkat")
      flash[:success] = 'Review updated successfully'
      redirect_to movie_reviews_path
    else
      flash[:notice] = 'Error! Review update unsuccessful'
      render :edit
    end
  end

  def destroy
    @review.destroy
    flash[:alert] = 'Review deleted successfully'
    redirect_to movie_reviews_path
  end

  private

  def set_movie
    @movie = Movie.find_by(slug: params[:movie_id])
  end

  def set_review
    @review = Review.find(params[:id])
    @movie = @review.movie
  end

  def review_params
    params.require(:review).permit(:stars, :comment)
  end
  
end
