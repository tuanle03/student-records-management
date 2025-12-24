class HeDaoTao < ApplicationRecord
  self.primary_key = "ma_he_dt"

  has_many :lops,  foreign_key: :ma_he_dt, primary_key: :ma_he_dt
  has_many :hssvs, foreign_key: :ma_hdt,   primary_key: :ma_he_dt

  def self.ransackable_associations(auth_object = nil)
    [ "hssvs", "lops" ]
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "don_vi_tg", "ghi_chu", "ma_he_dt", "ten", "thoi_gian_hoc", "updated_at" ]
  end
end
