import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "notificationsEnabled",
    "reminderEnabled",
    "reminderSettings",
    "reminderDetails"
  ]

  connect() {
    this.toggleAll()
  }

  toggleAll() {
    this.toggleReminderSettings()
    this.toggleReminderDetails()
  }

  toggleReminderSettings() {
    if (this.notificationsEnabledTarget.checked) {
      this.reminderSettingsTarget.classList.remove("opacity-50", "pointer-events-none")
    } else {
      this.reminderSettingsTarget.classList.add("opacity-50", "pointer-events-none")
    }
  }

  toggleReminderDetails() {
    if (this.notificationsEnabledTarget.checked &&
        this.reminderEnabledTarget.checked) {
      this.reminderDetailsTarget.classList.remove("opacity-50", "pointer-events-none")
    } else {
      this.reminderDetailsTarget.classList.add("opacity-50", "pointer-events-none")
    }
  }
}
