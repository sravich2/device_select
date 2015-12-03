class User < ActiveRecord::Base
  has_many :likes
  has_many :possessions
  has_many :liked_products, through: :likes, source: :products
  has_many :owned_products, through: :possessions, source: :products

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
