import { Controller } from "@hotwired/stimulus"

// Controls the hamburger menu toggle functionality
export default class extends Controller {
  static targets = ["menu"]

  connect() {
    // Ensure menu is hidden on connect
    this.isOpen = false
  }

  toggle() {
    this.isOpen = !this.isOpen

    if (this.hasMenuTarget) {
      if (this.isOpen) {
        this.menuTarget.classList.remove("hidden")
        // Add smooth animation
        this.menuTarget.style.opacity = "0"
        this.menuTarget.style.transform = "translateY(-10px)"

        // Trigger reflow for animation
        this.menuTarget.offsetHeight

        this.menuTarget.style.transition = "opacity 0.2s ease, transform 0.2s ease"
        this.menuTarget.style.opacity = "1"
        this.menuTarget.style.transform = "translateY(0)"
      } else {
        this.menuTarget.style.transition = "opacity 0.2s ease, transform 0.2s ease"
        this.menuTarget.style.opacity = "0"
        this.menuTarget.style.transform = "translateY(-10px)"

        // Wait for animation to complete before hiding
        setTimeout(() => {
          if (!this.isOpen) {
            this.menuTarget.classList.add("hidden")
          }
        }, 200)
      }
    }
  }
}
