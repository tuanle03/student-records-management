class AddFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :staff_code, :string
    add_column :users, :fullname, :string
    add_column :users, :military_rank, :string
  end
end
