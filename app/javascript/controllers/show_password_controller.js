import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle(event) {
    event.preventDefault()
    const button = event.currentTarget
    const wrapper = button.closest(".password-field-wrapper") || button.parentElement
    const input = wrapper.querySelector("input")
    const icon = button.querySelector("[data-show-password-target='icon']")
    const isPassword = input.type === "password"

    input.type = isPassword ? "text" : "password"
    icon.innerHTML = isPassword ? this.visibleIcon : this.hiddenIcon
    button.setAttribute("aria-label", isPassword ? "Ocultar contraseña" : "Mostrar contraseña")
  }

  get visibleIcon() {
    return `
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-5 w-5">
        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8Z" />
        <circle cx="12" cy="12" r="3" />
      </svg>`
  }

  get hiddenIcon() {
    return `
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="h-5 w-5">
        <path d="M17.94 17.94A10.06 10.06 0 0 1 12 20c-7 0-11-8-11-8a21.63 21.63 0 0 1 5.64-6.44" />
        <path d="M1 1l22 22" />
        <path d="M9.53 9.53A3.5 3.5 0 0 0 12 15.5a3.49 3.49 0 0 0 3.47-3.47" />
        <path d="M14.12 14.12l6.29 6.29" />
      </svg>`
  }
}
