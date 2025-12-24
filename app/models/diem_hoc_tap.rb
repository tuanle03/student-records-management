class DiemHocTap < ApplicationRecord
  belongs_to :hssv,    foreign_key: :ma_sv,       primary_key: :ma_sv
  belongs_to :mon_hoc, foreign_key: :ma_mon_hoc, primary_key: :ma_mon_hoc

  def self.ransackable_associations(auth_object = nil)
    %w[hssv mon_hoc]
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[
      id
      id_value
      ma_sv
      ma_mon_hoc
      ma_hoc_ky
      diem_gp
      diem_hp
      diem_tb
      diem_thi_lai_lan1
      diem_thi_lai_lan2
      ghi_chu
      created_at
      updated_at
    ]
  end

  def tinh_diem_tb
    return diem_tb if diem_tb.present?
    return if diem_gp.blank? || diem_hp.blank?

    (diem_gp * 0.4 + diem_hp * 0.6).round(2)
  end
end
