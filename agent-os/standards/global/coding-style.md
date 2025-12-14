## Ruby/Rails Coding Style

- **Ruby Style**: 2 spaces indentation, snake_case for methods/variables, CamelCase for classes
- **String Literals**: Prefer double quotes `"string"` for consistency
- **Method Length**: Keep methods under 10 lines; extract into smaller methods
- **Hash Syntax**: Use Ruby 3.1+ shorthand `{ name:, date: }` when key matches variable
- **Guard Clauses**: Return early instead of nested conditionals
- **Dead Code**: Delete unused methods, commented code, and unused imports
- **No Backward Compatibility Hacks**: Delete unused code; don't rename to `_var`

```ruby
# Good: Ruby style
class RaceService
  def initialize(race)
    @race = race
  end

  def upcoming?
    return false if @race.cancelled?

    @race.date >= Date.current
  end

  def format_location
    "#{@race.city.titleize}, #{@race.venue}"
  end
end

# Good: Guard clause
def process_race(race)
  return unless race.valid?
  return if race.past?

  race.publish!
end

# Good: Hash shorthand (Ruby 3.1+)
def create_race(name:, date:, city:)
  Race.create!({ name:, date:, city: })
end
```
