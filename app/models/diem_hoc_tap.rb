class DiemHocTap < ApplicationRecord
  belongs_to :hssv, foreign_key: :ma_sv
  belongs_to :mon_hoc, foreign_key: :ma_mon_hoc

  before_save :compute_diem_tb

  private

  def compute_diem_tb
    # ví dụ: TB = 0.3 * GP + 0.7 * HP (tuỳ bạn chỉnh)
    if diem_gp.present? && diem_hp.present?
      self.diem_tb = (0.3 * diem_gp + 0.7 * diem_hp).round(2)
    end
  end
end
