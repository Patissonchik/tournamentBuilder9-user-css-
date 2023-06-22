class User < ApplicationRecord
  has_many :tournaments, dependent: :destroy
  has_many :matches, through: :tournaments, dependent: :destroy
  has_many :match_stats, through: :matches, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
