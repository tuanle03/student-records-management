class Nganh < ApplicationRecord
  self.primary_key = "ma_nganh"

  has_many :lops,  foreign_key: :ma_nganh, primary_key: :ma_nganh
  has_many :hssvs, foreign_key: :ma_nganh, primary_key: :ma_nganh
end
