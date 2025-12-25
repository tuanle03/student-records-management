ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :role

  index do
    selectable_column
    id_column
    column :email
    column("Role") { |user| user.role_name }
    column :created_at
    actions
  end

  filter :email
  filter :role, as: :select, collection: User.roles.map { |value, label| [ label, value ] }
  filter :created_at

  form do |f|
    f.inputs "Thông tin tài khoản giáo viên" do
      f.input :email
      f.input :role,
        as: :select,
        collection: User.roles.map { |value, label| [ label, value ] },
        include_blank: false
      f.input :password, required: f.object.new_record?
      f.input :password_confirmation, required: f.object.new_record?
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :email
      row("Role") { |user| user.role_name }
      row :created_at
      row :updated_at
    end
  end
end
