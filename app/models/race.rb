class Race < ApplicationRecord
  # Enums
  enum :city, { tijuana: 0, rosarito: 1, tecate: 2, mexicali: 3 }
  enum :status, { draft: 0, published: 1, completed: 2, cancelled: 3 }

  # Validations
  validates :name, presence: true, length: { maximum: 255 }
  validates :start_time, presence: true
  validates :location_description, presence: true
  validates :city, presence: true
  validates :cost, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :registration_url, format: { with: /\Ahttps?:\/\// }, allow_blank: true
  validates :featured_image, presence: true
  validate :start_time_in_future, if: -> { draft? || published? }
  validate :has_at_least_one_race_distance
  validate :valid_image_types
  validate :valid_image_sizes
  validate :additional_images_limit

  # Associations
  has_many :race_distances, dependent: :destroy
  accepts_nested_attributes_for :race_distances

  # Attachments
  has_one_attached :featured_image
  has_many_attached :additional_images

  # Scopes
  scope :published, -> { where(status: :published) }
  scope :upcoming, -> { published.where("start_time > ?", Time.current) }
  scope :past, -> { where("start_time < ?", Time.current) }
  scope :by_city, ->(city) { where(city: city) }

  # Callbacks
  before_save :set_published_at

  private

  def set_published_at
    if status_changed? && published?
      self.published_at = Time.current
    end
  end

  def start_time_in_future
    return if start_time.blank?

    if start_time <= Time.current
      errors.add(:start_time, "must be in the future")
    end
  end

  def has_at_least_one_race_distance
    if race_distances.empty?
      errors.add(:base, "must have at least one race distance")
    end
  end

  def valid_image_types
    allowed_types = %w[image/jpeg image/png image/gif image/webp]

    if featured_image.attached? && !featured_image.content_type.in?(allowed_types)
      errors.add(:featured_image, "must be a JPEG, PNG, GIF, or WebP")
    end

    additional_images.each do |image|
      unless image.content_type.in?(allowed_types)
        errors.add(:additional_images, "must be JPEG, PNG, GIF, or WebP")
        break
      end
    end
  end

  def valid_image_sizes
    max_size = 5.megabytes

    if featured_image.attached? && featured_image.blob.byte_size > max_size
      errors.add(:featured_image, "must be less than 5MB")
    end

    additional_images.each do |image|
      if image.blob.byte_size > max_size
        errors.add(:additional_images, "must each be less than 5MB")
        break
      end
    end
  end

  def additional_images_limit
    if additional_images.length > 10
      errors.add(:additional_images, "cannot have more than 10 images")
    end
  end
end
