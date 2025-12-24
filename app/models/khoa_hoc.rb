class KhoaHoc < ApplicationRecord
  self.primary_key = "ma_khoa"

  has_many :lops,  foreign_key: :ma_khoa, primary_key: :ma_khoa
  has_many :hssvs, foreign_key: :ma_khoa, primary_key: :ma_khoa
end
