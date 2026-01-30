import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "preview"];

  connect() {
    this.element.classList.remove("border-slate-600");
    this.element.classList.add("border-slate-600");
  }

  dragOver(event) {
    event.preventDefault();
    this.element.classList.remove("border-slate-600");
    this.element.classList.add("border-amber-400", "bg-amber-50/10");
  }

  dragLeave(event) {
    event.preventDefault();
    this.element.classList.remove("border-amber-400", "bg-amber-50/10");
    this.element.classList.add("border-slate-600");
  }

  drop(event) {
    event.preventDefault();
    this.element.classList.remove("border-amber-400", "bg-amber-50/10");
    this.element.classList.add("border-slate-600");
    const files = event.dataTransfer.files;
    if (files.length > 0) {
      this.inputTarget.files = files;
      this.preview();
      this.autoSubmit();
    }
  }

  clickInput() {
    this.inputTarget.click();
  }

  preview() {
    const file = this.inputTarget.files[0];
    if (file && file.type.startsWith("image/")) {
      const reader = new FileReader();
      reader.onload = (e) => {
        this.previewTarget.src = e.target.result;
        this.previewTarget
          .closest("#avatar-live-preview")
          .classList.remove("hidden");
      };
      reader.readAsDataURL(file);
    } else {
      this.previewTarget.src = "";
      this.previewTarget
        .closest("#avatar-live-preview")
        .classList.add("hidden");
    }
  }

  autoSubmit() {
    // Auto-submit form sau khi chọn file
    const form = this.element.closest("form");
    if (form) {
      form.requestSubmit();
    }
  }
}
