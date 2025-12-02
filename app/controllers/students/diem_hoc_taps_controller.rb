module Students
  class DiemHocTapsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_student

    def index
      @diem_hoc_tap = @student.diem_hoc_taps.includes(:mon_hoc).order(:ma_hoc_ky, :ma_mon_hoc)
    end

    private

    def set_student
      @student = Hssv.find_by!(ma_sv: params[:student_ma_sv])
    end
  end
end
