class Hssv < ApplicationRecord
  self.primary_key = :ma_sv

  belongs_to :lop,       foreign_key: :ma_lop, optional: true
  belongs_to :khoa_hoc,  foreign_key: :ma_khoa, optional: true
  belongs_to :he_dao_tao, foreign_key: :ma_hdt, optional: true
  belongs_to :nganh, foreign_key: :ma_nganh, optional: true

  has_many :diem_hoc_taps, foreign_key: :ma_sv, dependent: :destroy
  has_many :diem_ren_luyens, foreign_key: :ma_sv, dependent: :destroy

  def ho_ten
    [ho_dem, ten].compact.join(" ")
  end
end
