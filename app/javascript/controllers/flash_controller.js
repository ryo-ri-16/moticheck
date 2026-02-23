import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    timeout: { type: Number, default: 2000 }
  }

  connect() {
    this.startTimer()
  }

  startTimer() {
    this.timeoutId = setTimeout(() => {
      this.fadeOut()
    }, this.timeoutValue)
  }

  close(event) {
    if (event) event.preventDefault()
    this.fadeOut()
  }

  fadeOut() {
    this.element.style.transition = "opacity 0.3s ease-out"
    this.element.style.opacity = "0"

    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
}
