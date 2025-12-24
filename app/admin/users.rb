ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :role

  index do
    selectable_column
    id_column
    column :email
    column :role
    column :created_at
    actions
  end

  filter :email
  filter :role
  filter :created_at

  form do |f|
    f.inputs "Thông tin tài khoản giáo viên" do
      f.input :email
      f.input :role, as: :select, collection: User.roles.keys, include_blank: false
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :email
      row :role
      row :created_at
      row :updated_at
    end
  end
end
