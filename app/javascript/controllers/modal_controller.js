import { Controller } from "@hotwired/stimulus"

// bootstrapのModalをimport
import {Modal} from "bootstrap"

// Connects to data-controller="modal"
export default class extends Controller {
  connect() {
    // モーダルの作成
    this.modal = new Modal(this.element)

    // モーダルの表示
    this.modal.show()
  }

  // アクションを定義
  // 保存成功時にモーダルを閉じる
  close(event) {

    // event.detail.successは、レスポンスが成功ならtrueを返す
    // バリデーションエラー時はモーダルを閉じたくないので、成功時のみ閉じる
    if (event.detail.success) {
      // モーダルを閉じる
      this.modal.hide()
    }

  }
}
