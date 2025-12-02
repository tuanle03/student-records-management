class DiemHocTap < ApplicationRecord
  belongs_to :hssv,    foreign_key: :ma_sv,       primary_key: :ma_sv
  belongs_to :mon_hoc, foreign_key: :ma_mon_hoc, primary_key: :ma_mon_hoc

  def tinh_diem_tb
    return diem_tb if diem_tb.present?
    return if diem_gp.blank? || diem_hp.blank?

    (diem_gp * 0.4 + diem_hp * 0.6).round(2)
  end
end
