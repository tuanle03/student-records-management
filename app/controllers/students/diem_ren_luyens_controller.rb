module Students
  class DiemRenLuyensController < ApplicationController
    before_action :authenticate_user!
    before_action :set_student

    def index
      @diem_ren_luyen = @student.diem_ren_luyens.order(:ma_nam_hoc, :thang)
    end

    private

    def set_student
      @student = Hssv.find_by!(ma_sv: params[:student_id])
    end
  end
end
