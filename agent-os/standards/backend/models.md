## Rails Model Standards

- **Singular Names**: Model `Race`, table `races`
- **Timestamps**: Always include `created_at`/`updated_at` (Rails default)
- **Validations First**: Define validations at top of model
- **Associations Next**: Define associations after validations
- **Scopes**: Use scopes for common queries
- **Callbacks Sparingly**: Prefer service objects over complex callbacks

```ruby
# Good: Well-organized model
class Race < ApplicationRecord
  # Validations
  validates :name, presence: true
  validates :date, presence: true
  validates :city, inclusion: { in: %w[tijuana rosarito tecate mexicali] }

  # Associations
  belongs_to :organizer, optional: true
  has_one_attached :photo

  # Scopes
  scope :upcoming, -> { where("date >= ?", Date.current).order(:date) }
  scope :in_city, ->(city) { where(city: city) }

  # Instance methods
  def past?
    date < Date.current
  end
end
```

**Database Constraints**: Add at database level via migrations:
```ruby
add_column :races, :name, :string, null: false
add_index :races, :slug, unique: true
add_foreign_key :races, :organizers
```
