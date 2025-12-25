class CreateDefaultAdminUser < ActiveRecord::Migration[8.0]
  def up
    return unless defined?(AdminUser)

    email = "admin@example.com"
    password = "password"

    AdminUser.reset_column_information

    admin = AdminUser.find_or_initialize_by(email: email)

    if admin.new_record?
      admin.password = password
      admin.password_confirmation = password
      admin.save!
    end
  end

  def down
    return unless defined?(AdminUser)

    email = ENV.fetch("ADMIN_EMAIL", "admin@example.com")
    AdminUser.where(email: email).delete_all
  end
end
