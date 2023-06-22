class Match < ApplicationRecord
  belongs_to :tournament
  has_one :match_stat, dependent: :destroy
  accepts_nested_attributes_for :match_stat
  before_destroy :destroy_related_match_stat
  validates :name, presence: true, length: { maximum: 20 }
  validates :players, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 30 }
  validates :statistics_fields, presence: true
  private

  def destroy_related_match_stat
    match_stat&.destroy
  end
end