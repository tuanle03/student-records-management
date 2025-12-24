class MonHoc < ApplicationRecord
  self.primary_key = "ma_mon_hoc"

  has_many :diem_hoc_taps, foreign_key: :ma_mon_hoc, primary_key: :ma_mon_hoc

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "ghi_chu", "ma_mon_hoc", "so_tin_chi", "ten", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "diem_hoc_taps" ]
  end

  def to_s
    ten
  end
end
