## Code Commenting Standards (Ruby)

- **Self-Documenting**: Use clear method and variable names; code should explain itself
- **Minimal Comments**: Comment only complex business logic, not obvious code
- **No Change Logs**: Don't document "what changed" or "fixed bug"; use git history
- **YARD for Public APIs**: Use YARD syntax only for public service classes if needed

```ruby
# Bad: Obvious comment
# Get the race name
def name
  @name
end

# Bad: Change log comment
# Updated 2024-01-15: Fixed validation bug
validates :date, presence: true

# Good: Complex logic explanation
# Races within 7 days show "Coming Soon" badge regardless of registration status
def display_badge
  return :coming_soon if days_until_race <= 7
  return :open if registration_open?
  :closed
end

# Good: YARD for public service (use sparingly)
# Calculates registration fee based on timing and membership status
# @param early_bird [Boolean] whether early bird pricing applies
# @return [Money] the calculated fee
def calculate_fee(early_bird: false)
  # ...
end
```
