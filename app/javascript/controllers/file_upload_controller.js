import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="file-upload"
export default class extends Controller {
  static targets = ["preview", "previewImg", "form"];

  connect() {
    // Optional: Log connection for debugging
    console.log("File upload controller connected");
  }

  preview(event) {
    const file = event.target.files[0];
    if (file && file.type.startsWith("image/")) {
      const reader = new FileReader();
      reader.onload = (e) => {
        this.previewTarget.classList.remove("hidden");
        this.previewImgTarget.src = e.target.result;

        // Auto-submit form after preview
        setTimeout(() => {
          this.formTarget.requestSubmit();
        }, 500);
      };
      reader.readAsDataURL(file);
    } else {
      this.previewTarget.classList.add("hidden");
    }
  }
}
