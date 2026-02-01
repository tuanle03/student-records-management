class AddIdToNganhs < ActiveRecord::Migration[8.0]
  def up
    remove_foreign_key :hssvs, :nganhs
    remove_foreign_key :lops, :nganhs

    execute "ALTER TABLE nganhs DROP CONSTRAINT nganhs_pkey;"

    execute "ALTER TABLE nganhs ADD COLUMN id SERIAL PRIMARY KEY;"

    add_index :nganhs, :ma_nganh, unique: true
  end

  def down
    remove_index :nganhs, :ma_nganh
    execute "ALTER TABLE nganhs DROP COLUMN id;"

    execute "ALTER TABLE nganhs ADD PRIMARY KEY (ma_nganh);"

    add_foreign_key :hssvs, :nganhs, column: :ma_nganh, primary_key: :ma_nganh
    add_foreign_key :lops, :nganhs, column: :ma_nganh, primary_key: :ma_nganh
  end
end
