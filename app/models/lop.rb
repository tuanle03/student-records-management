class Lop < ApplicationRecord
  self.primary_key = "ma_lop"

  # Validations
  validates :ma_lop, presence: true, uniqueness: true

  belongs_to :khoa_hoc,   foreign_key: :ma_khoa,  primary_key: :ma_khoa,  optional: true, class_name: "KhoaHoc"
  belongs_to :nganh,      foreign_key: :ma_nganh, primary_key: :ma_nganh, optional: true
  belongs_to :he_dao_tao, foreign_key: :ma_he_dt, primary_key: :ma_he_dt, optional: true
  belongs_to :giao_vien,  class_name: "User", foreign_key: :giao_vien_id, optional: true

  has_many :students, class_name: "Hssv", foreign_key: :ma_lop, primary_key: :ma_lop, dependent: :restrict_with_exception
  has_many :phan_loai_tap_thes, foreign_key: :ma_lop, primary_key: :ma_lop

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "ghi_chu", "giao_vien_id", "khoa_hoc", "ma_cb", "ma_he_dt", "ma_khoa", "ma_lop", "ma_nganh", "ten", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "giao_vien", "he_dao_tao", "khoa_hoc", "nganh", "phan_loai_tap_thes", "students" ]
  end

  def to_s
    ma_lop
  end
end
