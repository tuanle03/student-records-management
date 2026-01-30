class Hssv < ApplicationRecord
  # Validations
  validates :ma_sv, presence: true, uniqueness: true

  # Associations
  belongs_to :lop,        foreign_key: :ma_lop,   primary_key: :ma_lop,   optional: true
  belongs_to :nganh,      foreign_key: :ma_nganh, primary_key: :ma_nganh, optional: true
  belongs_to :khoa_hoc,   foreign_key: :ma_khoa,  primary_key: :ma_khoa,  optional: true
  belongs_to :he_dao_tao, foreign_key: :ma_hdt,   primary_key: :ma_he_dt, optional: true

  has_many :diem_hoc_taps,   foreign_key: :ma_sv, primary_key: :ma_sv, dependent: :destroy
  has_many :diem_ren_luyens, foreign_key: :ma_sv, primary_key: :ma_sv, dependent: :destroy

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 150, 150 ]
    attachable.variant :medium, resize_to_limit: [ 400, 400 ]
  end

  validates :avatar, content_type: { in: %w[image/jpeg image/gif image/png], message: "phải là hình ảnh JPEG, GIF hoặc PNG" },
                     size: { less_than: 5.megabytes, message: "không được vượt quá 5MB" }

  def self.ransackable_attributes(auth_object = nil)
    [
      "anh", "anh_chiem", "created_at", "dan_toc",
      "dien_thoai", "doi_tuong", "ghi_chu", "gioi_tinh",
      "ho_dem", "ho_khau_cha", "ho_khau_me", "ho_khau_vo",
      "ho_ten_cha", "ho_ten_me", "ho_ten_vo", "khu_vuc", "ktk_l",
      "ma_hdt", "ma_huyen", "ma_khoa", "ma_lop", "ma_nganh", "ma_sv",
      "nam_sinh_cha", "nam_sinh_me", "nam_sinh_vo", "ngay_cmnd", "ngay_dang",
      "ngay_doan", "ngay_sinh", "nghe_nghiep_cha", "nghe_nghiep_me", "nghe_nghiep_vo",
      "noi_cmnd", "noi_lam_cha", "noi_lam_me", "noi_lam_vo", "que_quan", "so_cmnd",
      "ten", "tom_tat_qtct", "ton_giao", "tru_quan", "updated_at"
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    [
      "diem_hoc_taps", "diem_ren_luyens", "he_dao_tao", "khoa_hoc", "lop", "nganh"
    ]
  end

  def ho_ten
    [ ho_dem, ten ].compact.join(" ")
  end

  def gioi_tinh_label
    case gioi_tinh
    when true  then "Nam"
    when false then "Nữ"
    else           "Chưa cập nhật"
    end
  end

  def to_s
    ma_sv
  end

  def to_param
    ma_sv
  end

  scope :search, ->(q) {
    if q.present?
      where("ma_sv ILIKE :q OR ho_dem ILIKE :q OR ten ILIKE :q", q: "%#{ActiveRecord::Base.sanitize_sql_like(q)}%")
    else
      all
    end
  }
end
