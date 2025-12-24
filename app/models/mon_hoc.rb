class MonHoc < ApplicationRecord
  self.primary_key = "ma_mon_hoc"

  has_many :diem_hoc_taps, foreign_key: :ma_mon_hoc, primary_key: :ma_mon_hoc
end
