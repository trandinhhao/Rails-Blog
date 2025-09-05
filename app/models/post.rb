class Post < ApplicationRecord
  has_many :comments
  belongs_to :user
  has_many :post_follows
  has_many :followers, through: :post_follows, source: :user

  has_many :post_ratings
  has_many :ratings, through: :post_ratings, source: :user
end
