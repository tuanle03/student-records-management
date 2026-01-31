ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation

  index title: "Danh sách quản trị viên" do
    selectable_column
    id_column
    column("Email", :email)
    column("Lần đăng nhập gần nhất", :current_sign_in_at)
    column("Số lần đăng nhập", :sign_in_count)
    column("Ngày tạo", :created_at)
    actions
  end

  show title: "Chi tiết quản trị viên" do
    attributes_table do
      row("ID") { |admin_user| admin_user.id }
      row("Email") { |admin_user| admin_user.email }
      row("Lần đăng nhập gần nhất") { |admin_user| admin_user.current_sign_in_at }
      row("Số lần đăng nhập") { |admin_user| admin_user.sign_in_count }
      row("Ngày tạo") { |admin_user| admin_user.created_at }
      row("Cập nhật lần cuối") { |admin_user| admin_user.updated_at }
    end
  end

  filter :email, label: "Email", as: :select, collection: AdminUser.pluck(:email)

  form do |f|
    f.inputs "Thông tin quản trị viên" do
      f.input :email, label: "Email"
      f.input :password, label: "Mật khẩu"
      f.input :password_confirmation, label: "Xác nhận mật khẩu"
    end
    f.actions
  end
end
