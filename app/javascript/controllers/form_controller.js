import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form"
export default class extends Controller {
  // コントローラーに紐づく要素（フォーム）をsubmitするアクション
  submit() {
    this.element.requestSubmit()
  }
}
