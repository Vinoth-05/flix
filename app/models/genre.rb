class Genre < ApplicationRecord
  has_many :characterizations
  has_many :movies, through: :characterizations
end
