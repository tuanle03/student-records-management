class Hssv < ApplicationRecord
  self.primary_key = "ma_sv"

  # Validations
  validates :ma_sv, presence: true, uniqueness: true

  # Associations
  belongs_to :lop,        foreign_key: :ma_lop,   primary_key: :ma_lop,   optional: true
  belongs_to :nganh,      foreign_key: :ma_nganh, primary_key: :ma_nganh, optional: true
  belongs_to :khoa_hoc,   foreign_key: :ma_khoa,  primary_key: :ma_khoa,  optional: true
  belongs_to :he_dao_tao, foreign_key: :ma_hdt,   primary_key: :ma_he_dt, optional: true

  has_many :diem_hoc_taps,   foreign_key: :ma_sv, primary_key: :ma_sv, dependent: :destroy
  has_many :diem_ren_luyens, foreign_key: :ma_sv, primary_key: :ma_sv, dependent: :destroy

  def ho_ten
    [ho_dem, ten].compact.join(" ")
  end

  def gioi_tinh_label
    case gioi_tinh
    when true  then "Nam"
    when false then "Nữ"
    else           "Chưa cập nhật"
    end
  end

  scope :search, ->(q) {
    if q.present?
      where("ma_sv ILIKE :q OR ho_dem ILIKE :q OR ten ILIKE :q", q: "%#{ActiveRecord::Base.sanitize_sql_like(q)}%")
    else
      all
    end
  }
end
