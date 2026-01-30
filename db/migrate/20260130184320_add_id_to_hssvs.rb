class AddIdToHssvs < ActiveRecord::Migration[8.0]
  def up
    # Drop foreign keys
    remove_foreign_key :diem_hoc_taps, :hssvs

    # Drop old primary key
    execute "ALTER TABLE hssvs DROP CONSTRAINT hssvs_pkey;"

    # Add new serial id as primary key
    execute "ALTER TABLE hssvs ADD COLUMN id SERIAL PRIMARY KEY;"

    # Add unique index on ma_sv BEFORE re-adding FK
    add_index :hssvs, :ma_sv, unique: true

    # Re-add foreign key (ma_sv vẫn reference ma_sv vì unique)
    add_foreign_key :diem_hoc_taps, :hssvs, column: :ma_sv, primary_key: :ma_sv
  end

  def down
    remove_foreign_key :diem_hoc_taps, :hssvs
    remove_index :hssvs, :ma_sv
    execute "ALTER TABLE hssvs DROP COLUMN id;"
    execute "ALTER TABLE hssvs ADD PRIMARY KEY (ma_sv);"
    add_foreign_key :diem_hoc_taps, :hssvs, column: :ma_sv, primary_key: :ma_sv
  end
end
