module Students
  class DiemHocTapsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_student
    before_action :authorize_teacher_for_student!

    def index
      @grades = @student.diem_hoc_taps.includes(:mon_hoc).order(:ma_hoc_ky, :ma_mon_hoc)
    end

    def new
      @grade = @student.diem_hoc_taps.new
      load_mon_hocs
    end

    def create
      @grade = @student.diem_hoc_taps.new(grade_params)
      if @grade.save
        redirect_to student_diem_hoc_taps_path(@student),
                    notice: "Thêm điểm học tập thành công."
      else
        load_mon_hocs
        flash.now[:alert] = "Không thể thêm điểm. Vui lòng kiểm tra lại."
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @grade = @student.diem_hoc_taps.find(params[:id])
      load_mon_hocs
    end

    def update
      @grade = @student.diem_hoc_taps.find(params[:id])
      if @grade.update(grade_params)
        redirect_to student_diem_hoc_taps_path(@student),
                    notice: "Cập nhật điểm học tập thành công."
      else
        load_mon_hocs
        flash.now[:alert] = "Không thể cập nhật điểm. Vui lòng kiểm tra lại."
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @grade = @student.diem_hoc_taps.find(params[:id])
      @grade.destroy
      redirect_to student_diem_hoc_taps_path(@student),
                  notice: "Đã xoá dòng điểm."
    end

    private

    def set_student
      key = params[:student_ma_sv] || params[:student_id] || params[:ma_sv] || params[:student]
      @student = Hssv.find_by!(ma_sv: key)
    end

    def authorize_teacher_for_student!
      return unless current_user.teacher?

      if @student.lop&.giao_vien_id != current_user.id
        redirect_to students_path,
                    alert: "Bạn không có quyền thao tác điểm của sinh viên này."
      end
    end

    def load_mon_hocs
      @mon_hocs = MonHoc.order(:ma_mon_hoc)
    end

    def grade_params
      params.require(:diem_hoc_tap).permit(
        :ma_mon_hoc,
        :ma_hoc_ky,
        :ghi_chu,
        :diem_gp,
        :diem_hp,
        :diem_tb,
        :diem_thi_lai_lan1,
        :diem_thi_lai_lan2
      )
    end
  end
end
