import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="file-upload"
export default class extends Controller {
  static values = { autoSubmit: { type: Boolean, default: false } };

  preview(event) {
    const file = event.target.files[0];
    if (file && file.type.startsWith("image/")) {
      const reader = new FileReader();
      reader.onload = (e) => {
        this.previewTarget.classList.remove("hidden");
        this.previewImgTarget.src = e.target.result;

        // Auto-submit form after preview (opt-in)
        if (this.autoSubmitValue && this.hasFormTarget) {
          setTimeout(() => {
            this.formTarget.requestSubmit();
          }, 500);
        }
      };
      reader.readAsDataURL(file);
    }
  }
}
