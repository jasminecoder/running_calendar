require "application_system_test_case"

class RaceCardsTest < ApplicationSystemTestCase
  setup do
    # Attach featured images to published races for testing
    @published_race = races(:published_race)
    @rosarito_race = races(:rosarito_half)
    @mexicali_race = races(:mexicali_5k)

    # Attach test images to fixtures
    [ @published_race, @rosarito_race, @mexicali_race ].each do |race|
      unless race.featured_image.attached?
        race.featured_image.attach(
          io: File.open(Rails.root.join("test/fixtures/files/test_image.jpg")),
          filename: "test_image.jpg",
          content_type: "image/jpeg"
        )
      end
    end
  end

  test "race card displays race name and featured image" do
    visit root_path

    # Find a race card and verify it displays the name
    within "[data-testid='race-card-#{@published_race.id}']" do
      assert_text @published_race.name

      # Verify image is present (either featured or placeholder)
      assert_selector "img"
    end
  end

  test "race card displays formatted date with calendar icon" do
    visit root_path

    within "[data-testid='race-card-#{@published_race.id}']" do
      # Check for calendar icon (SVG)
      assert_selector "[data-testid='calendar-icon']"

      # Date should be formatted in Spanish (e.g., "Sabado, 15 de Enero 2025")
      formatted_date = I18n.l(@published_race.start_time.to_date, format: :full)
      assert_text formatted_date
    end
  end

  test "race card displays location with place icon" do
    visit root_path

    within "[data-testid='race-card-#{@published_race.id}']" do
      # Check for location/place icon (SVG)
      assert_selector "[data-testid='place-icon']"

      # Should display location description
      assert_text @published_race.location_description
    end
  end

  test "race card displays cost as Gratis for free races" do
    visit root_path

    # Mexicali 5K is a free race (cost: 0)
    within "[data-testid='race-card-#{@mexicali_race.id}']" do
      assert_text "Gratis"
    end
  end

  test "race card displays formatted price for paid races" do
    visit root_path

    # Published race has cost of 50
    within "[data-testid='race-card-#{@published_race.id}']" do
      assert_text "$50 MXN"
    end
  end

  test "race card displays distance badges" do
    visit root_path

    # Published race has 10K and 21K distances
    within "[data-testid='race-card-#{@published_race.id}']" do
      assert_selector "[data-testid='distance-badges']"
      assert_text "10K"
      assert_text "21K"
    end
  end

  test "month subheadings display in correct format" do
    visit root_path

    # Should display month subheadings in Spanish format (e.g., "Enero 2025")
    # Find at least one month subheading
    assert_selector "[data-testid='month-subheading']"

    # Get the month of the first race and check for its subheading
    expected_month = I18n.l(@published_race.start_time.beginning_of_month, format: "%B %Y").capitalize
    assert_text expected_month
  end

  test "race card links to race show page" do
    visit root_path

    # Find the card link
    card_link = find("[data-testid='race-card-#{@published_race.id}'] a")

    # Verify the href points to the race show page
    assert_match %r{/races/#{@published_race.id}}, card_link[:href]

    # Click the card and verify navigation
    card_link.click
    assert_current_path race_path(@published_race)
  end

  # ============================================================================
  # STRATEGIC TESTS - Task Group 5.3 (Gap Analysis)
  # These tests fill critical coverage gaps identified during review
  # ============================================================================

  test "race card displays city badge" do
    visit root_path

    # Verify city badge displays correctly for each race
    within "[data-testid='race-card-#{@published_race.id}']" do
      assert_text @published_race.city.capitalize
    end

    within "[data-testid='race-card-#{@rosarito_race.id}']" do
      assert_text @rosarito_race.city.capitalize
    end

    within "[data-testid='race-card-#{@mexicali_race.id}']" do
      assert_text @mexicali_race.city.capitalize
    end
  end

  test "page displays multiple races across different months" do
    visit root_path

    # Verify all three published races are displayed
    assert_selector "[data-testid='race-card-#{@published_race.id}']"
    assert_selector "[data-testid='race-card-#{@rosarito_race.id}']"
    assert_selector "[data-testid='race-card-#{@mexicali_race.id}']"

    # Verify multiple race cards exist on the page
    assert_selector "[data-testid^='race-card-']", minimum: 3
  end

  test "responsive grid layout has correct structure" do
    visit root_path

    # Find the race cards grid container specifically (inside the container div)
    within ".container" do
      # Verify at least one grid exists with responsive classes for race cards
      grid_containers = all(".grid")
      assert grid_containers.any?, "Expected at least one grid container for race cards"

      # Check the first grid (race cards grid) has the responsive class structure
      race_grid = grid_containers.first
      assert race_grid[:class].include?("grid-cols-1"), "Grid should have mobile single column"
      assert race_grid[:class].include?("md:grid-cols-2"), "Grid should have tablet 2 columns"
      assert race_grid[:class].include?("lg:grid-cols-3"), "Grid should have desktop 3 columns"
    end
  end

  test "empty state displays when no upcoming races exist" do
    # Remove all upcoming published races by setting status to draft
    Race.upcoming.update_all(status: :draft)

    visit root_path

    # Verify empty state component is displayed
    assert_selector "[data-testid='empty-state']"
    assert_text "No hay carreras"
    assert_text "Vuelve pronto"

    # Verify no race cards are displayed
    assert_no_selector "[data-testid^='race-card-']"
  end

  test "skeleton loader element exists in race card structure" do
    visit root_path

    # Verify skeleton loader div exists within race cards (may be hidden after image loads)
    # Check for existence in the DOM, not visibility (images load fast in tests)
    within "[data-testid='race-card-#{@published_race.id}']" do
      # Use visible: :all to find elements that may be hidden
      assert_selector ".skeleton-loader", visible: :all
    end
  end

  test "race card with multiple distances displays all badges" do
    visit root_path

    # Rosarito half has 5K, 10K, and 21K distances
    within "[data-testid='race-card-#{@rosarito_race.id}']" do
      assert_selector "[data-testid='distance-badges']"
      assert_text "5K"
      assert_text "10K"
      assert_text "21K"
    end
  end
end
