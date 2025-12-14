## Minitest Testing Standards

- **Test Core Flows**: Focus on critical user paths (viewing races, submitting requests)
- **Skip Edge Cases**: Defer edge case testing until feature is complete
- **Descriptive Names**: `test_upcoming_races_ordered_by_date`
- **Fast Tests**: Mock external services; use fixtures for database records
- **System Tests**: Use Capybara for critical UI flows

```ruby
# test/models/race_test.rb
class RaceTest < ActiveSupport::TestCase
  test "upcoming scope returns future races ordered by date" do
    past = races(:past_race)
    upcoming = races(:upcoming_race)

    result = Race.upcoming

    assert_includes result, upcoming
    assert_not_includes result, past
  end

  test "validates city is in allowed list" do
    race = Race.new(name: "Test", date: 1.week.from_now, city: "invalid")

    assert_not race.valid?
    assert_includes race.errors[:city], "is not included in the list"
  end
end

# test/system/races_test.rb
class RacesTest < ApplicationSystemTestCase
  test "viewing upcoming races" do
    race = races(:upcoming_race)

    visit races_path

    assert_text race.name
    assert_text race.city.titleize
  end
end
```

**Fixtures** (`test/fixtures/races.yml`):
```yaml
upcoming_race:
  name: Tijuana Marathon
  date: <%= 2.weeks.from_now.to_date %>
  city: tijuana

past_race:
  name: Old Race
  date: <%= 1.week.ago.to_date %>
  city: rosarito
```

**Run Tests**: `bin/rails test` (unit) or `bin/rails test:system` (system)
