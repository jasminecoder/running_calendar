## Rails Validation Standards

- **Model Validations**: Define validations in models for data integrity
- **Database Constraints**: Add NOT NULL, UNIQUE, foreign keys in migrations
- **Strong Parameters**: Whitelist allowed params in controllers
- **Sanitize Input**: Rails auto-escapes ERB output; use `sanitize` helper for user HTML

```ruby
# Good: Model validations
class Race < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :date, presence: true
  validates :city, presence: true, inclusion: { in: %w[tijuana rosarito tecate mexicali] }
  validates :slug, uniqueness: true, format: { with: /\A[a-z0-9-]+\z/ }

  validate :date_must_be_future, on: :create

  private

  def date_must_be_future
    errors.add(:date, "must be in the future") if date.present? && date < Date.current
  end
end

# Good: Database constraints (migration)
class CreateRaces < ActiveRecord::Migration[8.0]
  def change
    create_table :races do |t|
      t.string :name, null: false
      t.date :date, null: false
      t.string :city, null: false
      t.string :slug, null: false, index: { unique: true }
      t.timestamps
    end
  end
end

# Good: Strong parameters
def race_params
  params.require(:race).permit(:name, :date, :city, :description, :photo)
end
```

**Form Errors Display**:
```erb
<% if @race.errors.any? %>
  <div class="bg-red-50 text-red-700 p-4 rounded mb-4">
    <ul>
      <% @race.errors.full_messages.each do |msg| %>
        <li><%= msg %></li>
      <% end %>
    </ul>
  </div>
<% end %>
```
