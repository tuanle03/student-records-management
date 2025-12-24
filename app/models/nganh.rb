class Nganh < ApplicationRecord
  self.primary_key = "ma_nganh"

  has_many :lops,  foreign_key: :ma_nganh, primary_key: :ma_nganh
  has_many :hssvs, foreign_key: :ma_nganh, primary_key: :ma_nganh

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "ghi_chu", "ma_nganh", "ten_nganh", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "hssvs", "lops" ]
  end
end
