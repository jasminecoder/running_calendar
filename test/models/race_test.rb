require "test_helper"

class RaceTest < ActiveSupport::TestCase
  test "validates presence of required fields" do
    race = Race.new

    assert_not race.valid?
    assert_includes race.errors[:name], "can't be blank"
    assert_includes race.errors[:start_time], "can't be blank"
    assert_includes race.errors[:location_description], "can't be blank"
    assert_includes race.errors[:city], "can't be blank"
  end

  test "city enum has correct values" do
    assert_equal({ "tijuana" => 0, "rosarito" => 1, "tecate" => 2, "mexicali" => 3 }, Race.cities)
  end

  test "status enum has correct values" do
    assert_equal({ "draft" => 0, "published" => 1, "completed" => 2, "cancelled" => 3 }, Race.statuses)
  end

  test "default status is draft for new records" do
    race = Race.new
    assert_equal "draft", race.status
  end

  test "published_at is set when status changes to published" do
    race = races(:draft_race)
    race.featured_image.attach(
      io: File.open(Rails.root.join("test/fixtures/files/test_image.jpg")),
      filename: "test.jpg",
      content_type: "image/jpeg"
    )
    assert_nil race.published_at

    race.status = :published
    race.save!

    assert_not_nil race.published_at
    assert_in_delta Time.current, race.published_at, 1.second
  end

  test "published_at is preserved when status changes away from published" do
    race = races(:published_race)
    race.featured_image.attach(
      io: File.open(Rails.root.join("test/fixtures/files/test_image.jpg")),
      filename: "test.jpg",
      content_type: "image/jpeg"
    )
    original_published_at = race.published_at

    race.status = :cancelled
    race.save!

    assert_equal original_published_at, race.published_at
  end

  test "scopes return correct records" do
    published = races(:published_race)
    draft = races(:draft_race)
    past = races(:past_race)

    assert_includes Race.published, published
    assert_not_includes Race.published, draft

    assert_includes Race.upcoming, published
    assert_not_includes Race.upcoming, past

    assert_includes Race.past, past
    assert_not_includes Race.past, published

    assert_includes Race.by_city(:tijuana), published
    assert_not_includes Race.by_city(:rosarito), published
  end

  test "has_many race_distances with dependent destroy" do
    race = races(:published_race)
    assert_equal 2, race.race_distances.count

    distance_ids = race.race_distances.pluck(:id)
    race.destroy

    distance_ids.each do |id|
      assert_nil RaceDistance.find_by(id: id)
    end
  end

  test "validates race has at least one race_distance" do
    race = Race.new(
      name: "Test Race",
      start_time: 2.weeks.from_now,
      location_description: "Test location",
      city: :tijuana,
      cost: 0
    )

    assert_not race.valid?
    assert_includes race.errors[:base], "must have at least one race distance"
  end
end
