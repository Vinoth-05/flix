class Movie < ApplicationRecord

  RATINGS = %w(G PG PG-13 R NC-17)

  validates :title, :released_on, :duration, presence: true, uniqueness: true
  validates :description, length: { minimum: 25 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
  # validates :image_file_name, format: {
  #   with: /\w+\.(jpg|png)\z/i,
  #   message: 'must be an PNG or JPG image'  
  # }
  validates :rating, inclusion: { in: RATINGS, message: "%{value} is not  valid" }
  validate :acceptable_image

  has_many :reviews, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :users, through: :likes, dependent: :destroy
  has_many :characterizations
  has_many :genres, through: :characterizations
  has_one_attached :main_image
  
  before_save :set_slug
  
  scope :released, lambda { where('released_on < ?', Time.now()) }
  scope :upcoming, lambda { where('released_on > ?', Time.now()) }
  scope :recent, lambda { released.order(released_on: :desc).limit(5) }
  scope :all_hit_movies, lambda { where('total_gross > ?', 300000000) }
  scope :all_flop_movies, lambda { where('total_gross < ?', 225000000) }

  def liked_by?(user)
    likes.exists?(user: user)
  end

  def like_count
    likes.count
  end

  def reviewd?(user)
    reviews.exists?(user: user)
  end

  def flop?
    avg = reviews.average(:stars)
    reviews_count = reviews.size
    if avg && (avg >= 4) && (reviews_count > 50)
      false 
    elsif total_gross > 225000000
      false
    else
      true
    end
  end

  # def self.released
  #   where('released_on < ?', Time.now)
  # end

  # def self.all_hit_movies
  #   where('total_gross > ?', 300000000)
  # end

  # def self.all_flop_movies
  #   where('total_gross < ?', 225000000)
  # end

  def self.recently_added
    where('released_on < ?', Time.now).order('released_on desc').limit(3)
  end

  def average_stars
    average = reviews.average(:stars)
  end

  def cult_movie?
    self.reviews.count > 1 && self.reviews.average(:stars) >= 4
  end

  # def reviews_count
  #   count = reviews.size
  # end

  def to_param
    title.parameterize
  end

  def set_slug
    self.slug = title.parameterize
  end

  def acceptable_image
    return unless main_image.attached?

    unless main_image.blob.byte_size <= 1.megabyte
      errors.add(:main_image, 'is greater than 1 MB')
    end

    acceptable_formats = ["image/png", "image/jpeg"]
    unless acceptable_formats.include? main_image.content_type
      errors.add(:main_image, 'must be a PNG or JPEG')
    end
  end

end
