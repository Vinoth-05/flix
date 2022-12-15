class Review < ApplicationRecord
  STARS = %w(1 2 3 4 5)

  belongs_to :movie
  belongs_to :user
  validates :comment, length: { minimum: 4 }
  validates :stars, numericality: { greater_than: 0, less_than_or_equal_to: 5,  only_integer: true, message: "must be between 1 and 5" }
  validates_uniqueness_of :user, scope: :movie, message: "You have already reviewed this movie"
  scope :past_n_days, -> (n) { where('created_at > ?', Time.now - n.day)}


  # def self.bg_job(name)
  #   puts "**********************************"
  #   puts "Hello #{name}!"
  # end
end
