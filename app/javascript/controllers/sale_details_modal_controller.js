import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "content"]

  open() {
    this.modalTarget.classList.remove("hidden")
  }

  close(event) {
    event.preventDefault()
    this.modalTarget.classList.add("hidden")
  }
}