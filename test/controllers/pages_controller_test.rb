require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    # Attach featured images to all races that will be used in tests
    attach_featured_images_to_fixtures
  end

  test "home page loads successfully" do
    get root_path

    assert_response :success
  end

  test "home page displays only upcoming published races" do
    get root_path

    # Upcoming published races should be assigned
    races_by_month = @controller.view_assigns["races_by_month"]
    all_races = races_by_month.values.flatten

    # Verify we have upcoming published races
    assert all_races.any?, "Should have at least one upcoming published race"

    # Verify all races are published and upcoming
    all_races.each do |race|
      assert race.published?, "Race '#{race.name}' should be published"
      assert race.start_time > Time.current, "Race '#{race.name}' should have future start_time"
    end

    # Verify draft, completed, and cancelled races are not included
    draft_race = races(:draft_race)
    past_race = races(:past_race)
    cancelled_race = races(:cancelled_race)

    assert_not_includes all_races, draft_race, "Draft races should not be included"
    assert_not_includes all_races, past_race, "Past races should not be included"
    assert_not_includes all_races, cancelled_race, "Cancelled races should not be included"
  end

  test "races are ordered by start_time ascending" do
    get root_path

    races_by_month = @controller.view_assigns["races_by_month"]
    all_races = races_by_month.values.flatten

    # Verify races are ordered by start_time ascending
    previous_start_time = nil
    all_races.each do |race|
      if previous_start_time
        assert race.start_time >= previous_start_time,
               "Race '#{race.name}' should come after or at same time as previous race"
      end
      previous_start_time = race.start_time
    end
  end

  test "races are grouped by month correctly" do
    get root_path

    races_by_month = @controller.view_assigns["races_by_month"]

    # Verify each key is a beginning_of_month date
    races_by_month.each do |month_key, races|
      assert_equal month_key.day, 1, "Month key should be first day of month"
      assert_equal month_key.hour, 0, "Month key should have hour 0"
      assert_equal month_key.min, 0, "Month key should have minute 0"

      # Verify all races in this group have start_times in this month
      races.each do |race|
        assert_equal race.start_time.beginning_of_month, month_key,
                     "Race '#{race.name}' should be in correct month group"
      end
    end
  end

  test "empty state handled when no upcoming races exist" do
    # Remove all upcoming published races by setting their start_time to past
    # or changing their status
    Race.upcoming.update_all(status: :draft)

    get root_path

    assert_response :success

    races_by_month = @controller.view_assigns["races_by_month"]
    assert races_by_month.empty?, "races_by_month should be empty when no upcoming races exist"
  end

  private

  def attach_featured_images_to_fixtures
    test_image_path = Rails.root.join("test/fixtures/files/test_image.jpg")

    Race.find_each do |race|
      unless race.featured_image.attached?
        race.featured_image.attach(
          io: File.open(test_image_path),
          filename: "test.jpg",
          content_type: "image/jpeg"
        )
      end
    end
  end
end
