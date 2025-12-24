module Students
  class DiemRenLuyensController < ApplicationController
    before_action :authenticate_user!
    before_action :set_student

    def index
      @ren_luyens = @student.diem_ren_luyens.order(:ma_nam_hoc, :ma_hoc_ky, :thang)
    end

    private

    def set_student
      @student = Hssv.find(params[:student_ma_sv])
    end
  end
end
