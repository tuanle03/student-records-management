module Students
  class DiemRenLuyensController < ApplicationController
    before_action :authenticate_user!
    before_action :set_student
    before_action :authorize_teacher_for_student!
    before_action :set_diem_ren_luyen, only: %i[edit update destroy]

    def index
      @ren_luyens = @student.diem_ren_luyens.order(:ma_nam_hoc, :ma_hoc_ky, :thang)
    end

    def new
      @diem_ren_luyen = @student.diem_ren_luyens.new
    end

    def create
      @diem_ren_luyen = @student.diem_ren_luyens.new(diem_ren_luyen_params)
      if @diem_ren_luyen.save
        redirect_to student_diem_ren_luyens_path(@student),
                    notice: "Đã thêm điểm rèn luyện."
      else
        flash.now[:alert] = "Không thể lưu điểm rèn luyện."
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @diem_ren_luyen.update(diem_ren_luyen_params)
        redirect_to student_diem_ren_luyens_path(@student),
                    notice: "Đã cập nhật điểm rèn luyện."
      else
        flash.now[:alert] = "Không thể cập nhật điểm rèn luyện."
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @diem_ren_luyen.destroy
      redirect_to student_diem_ren_luyens_path(@student),
                  notice: "Đã xoá điểm rèn luyện."
    end

    private

    def set_student
      key = params[:student_ma_sv] || params[:student_id] || params[:ma_sv] || params[:student]
      @student = Hssv.find_by!(ma_sv: key)
    end

    def set_diem_ren_luyen
      @diem_ren_luyen = @student.diem_ren_luyens.find(params[:id])
    end

    # giáo viên chỉ được sửa điểm lớp mình
    def authorize_teacher_for_student!
      return unless current_user.teacher?
      if @student.lop&.giao_vien_id != current_user.id
        redirect_to students_path, alert: "Bạn không có quyền thao tác điểm của sinh viên này."
      end
    end

    def diem_ren_luyen_params
      params.require(:diem_ren_luyen)
            .permit(:ma_nam_hoc, :ma_hoc_ky, :thang, :diem, :ghi_chu)
    end
  end
end
