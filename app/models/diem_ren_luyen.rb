class DiemRenLuyen < ApplicationRecord
  belongs_to :hssv, foreign_key: :ma_sv, primary_key: :ma_sv, optional: true

  validates :diem, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  def self.ransackable_associations(auth_object = nil)
    [ "hssv" ]
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "diem", "ghi_chu", "id", "id_value", "ma_hoc_ky", "ma_nam_hoc", "ma_sv", "thang", "updated_at" ]
  end
end
