class RaceDistance < ApplicationRecord
  # Enums
  enum :distance_unit, { km: 0, miles: 1 }

  # Validations
  validates :distance_value, presence: true, numericality: { greater_than: 0 }
  validates :distance_value, uniqueness: { scope: :race_id }
  validates :distance_unit, presence: true

  # Associations
  belongs_to :race

  # Returns formatted distance string like "5K", "10K", "21K" for km
  # or "10 mi", "13.1 mi" for miles
  def display_distance
    if km?
      "#{distance_value.to_i}K"
    else
      "#{distance_value} mi"
    end
  end
end
