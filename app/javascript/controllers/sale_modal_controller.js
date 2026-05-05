import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "productName", "productId"]

  open(event) {
    event.preventDefault()
    const button = event.currentTarget
    const productId = button.dataset.productId
    const productName = button.dataset.productName

    this.productNameTarget.textContent = productName
    this.productIdTarget.value = productId
    this.modalTarget.classList.remove("hidden")
  }

  close(event) {
    event.preventDefault()
    this.modalTarget.classList.add("hidden")
  }
}
