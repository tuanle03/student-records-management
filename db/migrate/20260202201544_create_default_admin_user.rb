class CreateDefaultAdminUser < ActiveRecord::Migration[8.0]
  def up
    AdminUser.find_or_create_by!(email: 'admin@qlhv.local') do |u|
      u.password = 'admin123'
      u.password_confirmation = 'admin123'
    end
  end

  def down
    AdminUser.find_by(email: 'admin@qlhv.local')&.destroy
  end
end
