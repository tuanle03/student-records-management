class HeDaoTao < ApplicationRecord
  self.primary_key = "ma_he_dt"

  has_many :lops,  foreign_key: :ma_he_dt, primary_key: :ma_he_dt
  has_many :hssvs, foreign_key: :ma_hdt,   primary_key: :ma_he_dt
end
