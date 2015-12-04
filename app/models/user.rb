class User < ActiveRecord::Base
  has_many :likes
  has_many :dislikes
  has_many :possessions
  has_many :liked_products, through: :likes, source: :product
  has_many :disliked_products, through: :dislikes, source: :product
  has_many :owned_products, through: :possessions, source: :product

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
