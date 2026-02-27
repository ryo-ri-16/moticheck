import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["weeklySection"]

  connect() {
    this.toggle()
  }

  toggle() {
    const checked = this.element.querySelector(
      "input[name='list_template[repeat_type]']:checked"
    )?.value

    if (this.hasWeeklySectionTarget) {
      if (checked === "weekly") {
        this.weeklySectionTarget.classList.remove("hidden")
      } else {
        this.weeklySectionTarget.classList.add("hidden")
      }
    }
  }
}
