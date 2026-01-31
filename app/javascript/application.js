// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";

import AvatarUploadController from "./controllers/avatar_upload_controller";
application.register("avatar-upload", AvatarUploadController);
