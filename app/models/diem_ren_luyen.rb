class DiemRenLuyen < ApplicationRecord
  belongs_to :hssv, foreign_key: :ma_sv, primary_key: :ma_sv, optional: true

  validates :diem, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
end
