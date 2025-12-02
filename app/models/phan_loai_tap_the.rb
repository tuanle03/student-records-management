class PhanLoaiTapThe < ApplicationRecord
  belongs_to :lop, foreign_key: :ma_lop, primary_key: :ma_lop, optional: true
end
