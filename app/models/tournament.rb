class Tournament < ApplicationRecord
	belongs_to :user
	has_many :matches, dependent: :destroy
	has_many :match_stats, through: :matches, dependent: :destroy
	validates :name, presence: true
  validates :description, presence: true, length: { maximum: 100 }

end
