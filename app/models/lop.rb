class Lop < ApplicationRecord
  self.primary_key = "ma_lop"

  # Validations
  validates :ma_lop, presence: true, uniqueness: true

  belongs_to :khoa_hoc,   foreign_key: :ma_khoa,  primary_key: :ma_khoa,  optional: true
  belongs_to :nganh,      foreign_key: :ma_nganh, primary_key: :ma_nganh, optional: true
  belongs_to :he_dao_tao, foreign_key: :ma_he_dt, primary_key: :ma_he_dt, optional: true
  belongs_to :giao_vien,  class_name: "User", foreign_key: :giao_vien_id, optional: true

  has_many :students, class_name: "Hssv", foreign_key: :ma_lop, primary_key: :ma_lop, dependent: :restrict_with_exception
  has_many :phan_loai_tap_thes, foreign_key: :ma_lop, primary_key: :ma_lop
end
