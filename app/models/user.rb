class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :posts
  has_many :comments
  has_many :post_follows # ban ghi trung gian
  has_many :followed_posts, through: :post_follows, source: :post # truc tiep post

  has_many :post_ratings # ban ghi trung gian
  has_many :rating_posts, through: :post_ratings, source: :post # truc tiep post

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
