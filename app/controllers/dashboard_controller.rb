class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @total_students = Hssv.count
    @total_classes = Lop.count
    @total_majors = Nganh.count
    @total_programs = HeDaoTao.count

    @recent_students = Hssv.order(created_at: :desc).limit(5)
    @current_user_name = current_user.email
  end
end
