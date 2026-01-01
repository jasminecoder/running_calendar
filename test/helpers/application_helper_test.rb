# frozen_string_literal: true

require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  # Test Spanish date formatting with proper accents
  test "format_race_date returns Spanish date format" do
    # Saturday, January 4, 2025
    date = Date.new(2025, 1, 4)

    result = I18n.l(date, format: :full)

    # Expected format with accent on Sabado -> Sábado
    assert_equal "Sábado, 04 de Enero 2025", result
  end

  # Test month formatting for groupings
  test "format_month returns Spanish month-year format" do
    date = Date.new(2025, 1, 15)

    result = I18n.l(date, format: :month_year)

    assert_equal "Enero 2025", result
  end

  # Test Gratis display for zero cost races
  test "format_race_cost returns Gratis for zero cost" do
    result = format_race_cost(0)

    assert_equal "Gratis", result
  end

  # Test currency formatting for paid races
  test "format_race_cost returns formatted price for paid races" do
    result = format_race_cost(250)

    assert_equal "$250 MXN", result
  end
end
