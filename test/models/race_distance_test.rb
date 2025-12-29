require "test_helper"

class RaceDistanceTest < ActiveSupport::TestCase
  test "validates presence of required fields" do
    distance = RaceDistance.new

    assert_not distance.valid?
    assert_includes distance.errors[:distance_value], "can't be blank"
    assert_includes distance.errors[:distance_unit], "can't be blank"
  end

  test "distance_unit enum has correct values" do
    assert_equal({ "km" => 0, "miles" => 1 }, RaceDistance.distance_units)
  end

  test "validates distance_value is greater than zero" do
    race = races(:draft_race)

    zero_distance = RaceDistance.new(race: race, distance_value: 0, distance_unit: :km)
    assert_not zero_distance.valid?
    assert_includes zero_distance.errors[:distance_value], "must be greater than 0"

    negative_distance = RaceDistance.new(race: race, distance_value: -5, distance_unit: :km)
    assert_not negative_distance.valid?
  end

  test "validates uniqueness of distance_value scoped to race" do
    race = races(:draft_race)
    existing = race_distances(:draft_race_5k)

    duplicate = RaceDistance.new(
      race: race,
      distance_value: existing.distance_value,
      distance_unit: :km
    )

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:distance_value], "has already been taken"
  end

  test "belongs_to race association" do
    distance = race_distances(:published_race_10k)

    assert_equal races(:published_race), distance.race
  end
end
