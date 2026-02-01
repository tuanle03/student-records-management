class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ROLE_TEACHER = 0
  ROLE_STAFF   = 1

  has_many :homeroom_classes,
           class_name: "Lop",
           foreign_key: :giao_vien_id,
           inverse_of: :giao_vien,
           dependent: :nullify

  scope :teachers, -> { where(role: ROLE_TEACHER) }
  scope :staffs,   -> { where(role: ROLE_STAFF) }

  def self.ransackable_attributes(auth_object = nil)
    %w[id email role created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[homeroom_classes]
  end

  def self.roles
    {
      ROLE_TEACHER => "Chủ nhiệm trung đội",
      ROLE_STAFF   => "Nhân viên / Phòng đào tạo"
    }
  end

  def role_name
    self.class.roles[role] || "Không rõ"
  end


  def teacher?
    role == ROLE_TEACHER
  end

  def staff?
    role == ROLE_STAFF
  end

  def to_s
    email
  end
end
