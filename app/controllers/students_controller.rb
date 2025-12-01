class StudentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_student, only: :show

  def index
    @q = params[:q].to_s.strip

    @students = Hssv
                  .includes(:lop, :nganh)
                  .order(:ma_sv)

    if @q.present?
      @students = @students.where(
        "ma_sv ILIKE :q OR ho_dem ILIKE :q OR ten ILIKE :q",
        q: "%#{@q}%"
      )
    end
  end

  def show
    @diem_hoc_tap   = @student.diem_hoc_taps.includes(:mon_hoc).order(:ma_hoc_ky, :ma_mon_hoc)
    @diem_ren_luyen = @student.diem_ren_luyens.order(:ma_nam_hoc, :thang)
  end

  private

  def set_student
    @student = Hssv.find_by!(ma_sv: params[:id])
  end
end
