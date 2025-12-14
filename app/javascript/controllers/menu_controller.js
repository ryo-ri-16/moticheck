import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    this.boundClose = this.close.bind(this)
  }

  disconnect() {
    document.removeEventListener("click", this.boundClose)
  }

  toggle(event) {
    event.stopPropagation()
    if (this.menuTarget.classList.contains("hidden")) {
      this.open()
    } else {
      this.close()
    }
  }

  open() {
    this.menuTarget.classList.remove("hidden")
    // 次のクリックでメニューを閉じるためのリスナーを追加
    setTimeout(() => {
      document.addEventListener("click", this.boundClose)
    }, 0)
  }

  close() {
    this.menuTarget.classList.add("hidden")
    document.removeEventListener("click", this.boundClose)
  }
}

document.addEventListener("turbo:load", () => {
  console.log("MENU JS LOADED")
  document.addEventListener("click", (e) => {
    const btn = e.target.closest(".menu-btn")
    if (!btn) return

    const wrapper = btn.closest(".menu-wrapper")
    if (!wrapper) return

    const menu = wrapper.querySelector(".menu")
    if (menu) {
      menu.classList.toggle("hidden")
    }
  })
})
