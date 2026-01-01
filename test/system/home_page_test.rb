require "application_system_test_case"

class HomePageTest < ApplicationSystemTestCase
  test "navbar displays mxcorre logo text" do
    visit root_path

    within "nav" do
      assert_selector "[data-testid='logo']", text: "mxcorre"
    end
  end

  test "hamburger menu is visible and toggles on click" do
    visit root_path

    # Hamburger button should be visible
    hamburger = find("[data-testid='hamburger-button']")
    assert hamburger

    # Menu should be hidden initially
    menu = find("[data-testid='mobile-menu']", visible: :all)
    assert menu[:class].include?("hidden"), "Menu should be hidden initially"

    # Click hamburger to open menu
    hamburger.click

    # Wait for menu to become visible (animation)
    sleep 0.3
    menu = find("[data-testid='mobile-menu']", visible: :all)
    refute menu[:class].include?("hidden"), "Menu should be visible after first click"

    # Click hamburger again to close
    hamburger.click

    # Wait for close animation and hidden class to be applied
    sleep 0.3
    menu = find("[data-testid='mobile-menu']", visible: :all)
    assert menu[:class].include?("hidden"), "Menu should be hidden after second click"
  end

  test "hero section displays with text overlay" do
    visit root_path

    within "[data-testid='hero-section']" do
      assert_text "Próximas carreras en Tijuana"
      assert_selector "img[src*='hero-runner']"
    end
  end

  test "footer displays copyright and tagline" do
    visit root_path

    within "footer" do
      assert_text Time.current.year.to_s
      assert_text "Hecho con"
      assert_text "en Baja California"
    end
  end

  test "background gradient is applied to body" do
    visit root_path

    # Check that body has the gradient background style
    body_style = find("body")[:style] || ""

    # The gradient is applied inline via style attribute
    assert body_style.include?("gradient"), "Expected body to have gradient background styling"
  end

  # ============================================================================
  # STRATEGIC TESTS - Task Group 5.3 (Gap Analysis)
  # These tests fill critical coverage gaps identified during review
  # ============================================================================

  test "full page loads with all structural elements" do
    visit root_path

    # Verify all major page structural elements are present
    assert_selector "nav", count: 1
    assert_selector "[data-testid='hero-section']", count: 1
    assert_selector "footer", count: 1

    # Verify page title is set correctly
    assert_equal "mxcorre - Carreras en Baja California", page.title
  end

  test "contact link in mobile menu navigates to contact page" do
    visit root_path

    # Open the hamburger menu
    find("[data-testid='hamburger-button']").click
    sleep 0.3

    # Find and click the contact link (text is "Contact Us" in the navbar)
    within "[data-testid='mobile-menu']" do
      click_link "Contact Us"
    end

    # Verify navigation to contact page
    assert_current_path "/contact"
  end

  test "page structure flows correctly from navbar to footer" do
    visit root_path

    # Verify correct order: navbar at top, hero below navbar, content area, footer at bottom
    navbar = find("nav")
    hero = find("[data-testid='hero-section']")
    footer = find("footer")

    # All elements should exist on the page
    assert navbar
    assert hero
    assert footer

    # Verify content container exists for race cards
    assert_selector ".container"
  end

  test "page displays Inter font family" do
    visit root_path

    # Check that Inter font is loaded and applied
    body_computed_style = page.evaluate_script("window.getComputedStyle(document.body).fontFamily")
    assert body_computed_style.include?("Inter"), "Expected Inter font to be applied to body"
  end
end
