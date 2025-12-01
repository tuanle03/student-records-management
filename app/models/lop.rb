class Lop < ApplicationRecord
  self.primary_key = :ma_lop

  belongs_to :khoa_hoc,  foreign_key: :ma_khoa,  optional: true
  belongs_to :nganh,     foreign_key: :ma_nganh, optional: true
  belongs_to :he_dao_tao, foreign_key: :ma_he_dt, optional: true

  has_many :hssvs, foreign_key: :ma_lop
end
