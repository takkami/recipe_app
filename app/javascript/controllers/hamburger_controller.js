import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "button"]

  connect() {
    // メニューが開いている状態で画面サイズが変わったら閉じる
    this.mediaQuery = window.matchMedia("(min-width: 769px)")
    this.handleBreakpointChange = (e) => {
      if (e.matches) this.close()
    }
    this.mediaQuery.addEventListener("change", this.handleBreakpointChange)
    this.updateAria(false)
  }

  disconnect() {
    this.mediaQuery.removeEventListener("change", this.handleBreakpointChange)
  }

  toggle() {
    const isOpen = this.menuTarget.classList.contains("header__mobile-menu--open")

    if (isOpen) {
      this.close()
    } else {
      this.open()
    }
  }

  open() {
    this.menuTarget.classList.add("header__mobile-menu--open")
    this.element.querySelector(".hamburger").classList.add("hamburger--active")
    this.updateAria(true)
    document.body.style.overflow = "hidden" // スクロール防止
  }

  close() {
    this.menuTarget.classList.remove("header__mobile-menu--open")
    this.element.querySelector(".hamburger").classList.remove("hamburger--active")
    this.updateAria(false)
    document.body.style.overflow = "" // スクロール復帰
  }

  // メニュー外をクリックしたら閉じる
  closeOnClickOutside(event) {
    if (!this.menuTarget.classList.contains("header__mobile-menu--open")) return
    if (this.menuTarget.contains(event.target)) return
    if (this.buttonTarget.contains(event.target)) return
    this.close()
  }

  updateAria(isOpen) {
    this.buttonTarget.setAttribute("aria-expanded", String(isOpen))
    this.menuTarget.setAttribute("aria-hidden", String(!isOpen))
  }
}
