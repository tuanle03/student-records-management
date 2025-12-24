class GradesController < ApplicationController
  before_action :authenticate_user!

  def index
    @subjects = MonHoc.order(:ma_mon_hoc)
  end

  def show
    @subject = MonHoc.find_by!(ma_mon_hoc: params[:id])
    @grades = DiemHocTap.includes(:hssv)
                        .where(ma_mon_hoc: @subject.ma_mon_hoc)
                        .order(:ma_sv)
    if current_user.teacher?
      allowed_classes = current_user.homeroom_classes.select(:ma_lop)
      @grades = @grades.where(ma_sv: Hssv.where(ma_lop: allowed_classes).select(:ma_sv))
    end
  end

  def new
    @grade = DiemHocTap.new
    @subjects = MonHoc.order(:ma_mon_hoc)
    if current_user.teacher?
      allowed_class_codes = current_user.homeroom_classes.select(:ma_lop)
      @students = Hssv.where(ma_lop: allowed_class_codes).order(:ma_sv)
    else
      @students = Hssv.order(:ma_sv)
    end
    @selected_subject = MonHoc.find_by(ma_mon_hoc: params[:ma_mon_hoc])
  end

  def create
    @grade = DiemHocTap.new(grade_params)
    if @grade.save
      redirect_to grade_path(@grade.ma_mon_hoc), notice: "Thêm điểm thành công."
    else
      @subjects         = MonHoc.order(:ma_mon_hoc)
      @students         = Hssv.order(:ma_sv)
      @selected_subject = MonHoc.find_by(ma_mon_hoc: params.dig(:diem_hoc_tap, :ma_mon_hoc))
      render :new, status: :unprocessable_entity
    end
  end

  private

  def grade_params
    params.require(:diem_hoc_tap).permit(
      :ma_sv, :ma_mon_hoc, :ma_hoc_ky,
      :diem_gp, :diem_hp, :diem_tb,
      :diem_thi_lai_lan1, :diem_thi_lai_lan2,
      :ghi_chu
    )
  end
end
