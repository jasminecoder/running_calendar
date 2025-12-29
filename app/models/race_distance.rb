class RaceDistance < ApplicationRecord
  # Enums
  enum :distance_unit, { km: 0, miles: 1 }

  # Validations
  validates :distance_value, presence: true, numericality: { greater_than: 0 }
  validates :distance_value, uniqueness: { scope: :race_id }
  validates :distance_unit, presence: true

  # Associations
  belongs_to :race
end
