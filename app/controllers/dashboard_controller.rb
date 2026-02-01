class DashboardController < ApplicationController
  before_action :authenticate_user!

  # def index
  #   @total_students = Hssv.count
  #   @total_classes = Lop.count
  #   @total_majors = Nganh.count
  #   @total_programs = HeDaoTao.count
  #
  #   @recent_students = Hssv.order(created_at: :desc).limit(5)
  #   @current_user_name = current_user.email
  # end

  def index
    @current_user_name = current_user.email
    @current_user_role = current_user.role_name

    if current_user.teacher?
      classes_scope = current_user.homeroom_classes
      students_scope = Hssv.where(ma_lop: classes_scope.select(:ma_lop))
      grades_scope   = DiemHocTap.where(ma_sv: students_scope.select(:ma_sv))

      @total_students = students_scope.count
      @total_classes  = classes_scope.count
      @total_grades   = grades_scope.count
    else
      @total_students = Hssv.count
      @total_classes  = Lop.count
      @total_grades   = DiemHocTap.count
    end
  end
end
