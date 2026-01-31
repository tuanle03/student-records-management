ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :role

  index title: "Danh sách tài khoản giáo viên" do
    selectable_column
    id_column
    column "Email", :email
    column "Vai trò" do |user|
      user.role_name
    end
    column "Ngày tạo", :created_at
    actions
  end

  filter :email, label: "Email", as: :select, collection: User.pluck(:email)
  filter :role, as: :select, collection: User.roles.map { |value, label| [ label, value ] }, label: "Vai trò"

  form do |f|
    f.inputs "Thông tin tài khoản giáo viên" do
      f.input :email, label: "Email"
      f.input :role,
        as: :select,
        collection: User.roles.map { |value, label| [ label, value ] },
        include_blank: false,
        label: "Vai trò"
      f.input :password, label: "Mật khẩu", required: f.object.new_record?
      f.input :password_confirmation, label: "Xác nhận mật khẩu", required: f.object.new_record?
    end
    f.actions
  end

  show title: "Chi tiết tài khoản giáo viên" do
    attributes_table do
      row("ID") { |user| user.id }
      row("Email") { |user| user.email }
      row("Vai trò") { |user| user.role_name }
      row("Ngày tạo") { |user| user.created_at }
      row("Cập nhật lần cuối") { |user| user.updated_at }
    end
  end
end
