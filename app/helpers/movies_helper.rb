module MoviesHelper
  def total_gross(movie)
    if movie.flop?
      "Flop!"
    else
      number_to_currency(movie.total_gross, precision:0)
    end
  end

  def average_stars(movie)
    avg = movie.average_stars
    if avg
      number_with_precision(avg, precision: 1)
    else
      "No reviews yet"
    end
  end

  def display_image(movie)
    if movie.main_image.attached?
      return movie.main_image.variant(resize_to_limit: [150, nil])
    else
      return "placeholder"
    end
  end

  # def cult_movie(movie)
  #   avg = movie.average_stars
  #   reviews_count = movie.reviews_count
  #   if avg && (avg >= 4) && (reviews_count > 50)
  #     "Hit Movie"
  #   else
  #     "Flop Movie"
  #   end
  # end
end
