ActiveAdmin.register User do
  menu label: "Tài khoản giáo viên", parent: "Quản lý người dùng", priority: 2

  permit_params :email, :password, :password_confirmation, :role, :staff_code, :fullname, :military_rank

  filter :email, label: "Email", as: :select, collection: proc { User.pluck(:email) }
  filter :role, as: :select, collection: proc { User.roles.map { |value, label| [ label, value ] } }, label: "Vai trò"

  index title: "Danh sách tài khoản giáo viên" do
    selectable_column
    id_column
    column "Mã cán bộ", :staff_code
    column "Email", :email
    column "Họ và tên" do |user|
      user.fullname.presence || "(Chưa cập nhật)"
    end
    column "Cấp bậc quân hàm" do |user|
      user.military_rank.presence || "(Chưa cập nhật)"
    end
    column "Vai trò" do |user|
      user.role_name
    end
    column "Ngày tạo", :created_at
    actions
  end

  form do |f|
    f.inputs "Thông tin tài khoản giáo viên" do
      f.input :staff_code, label: "Mã cán bộ"
      f.input :email, label: "Email", required: f.object.new_record?
      f.input :fullname, label: "Họ và tên", required: f.object.new_record?
      f.input :military_rank, label: "Cấp bậc quân hàm"
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
      row("Mã cán bộ") { |user| user.staff_code }
      row("Email") { |user| user.email }
      row("Họ và tên") { |user| user.fullname.presence || "(Chưa cập nhật)" }
      row("Cấp bậc quân hàm") { |user| user.military_rank.presence || "(Chưa cập nhật)" }
      row("Vai trò") { |user| user.role_name }
      row("Ngày tạo") { |user| user.created_at }
      row("Cập nhật lần cuối") { |user| user.updated_at }
    end
  end
end
