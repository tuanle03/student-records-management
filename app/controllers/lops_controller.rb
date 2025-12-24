class LopsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lop, only: %i[show edit update destroy]
  before_action :load_collections, only: %i[new edit create update]
  before_action :ensure_teacher_can_see_lop!, only: %i[show]

  def index
    scope = Lop.includes(:khoa_hoc, :nganh, :he_dao_tao)

    if current_user.teacher?
      scope = scope.where(giao_vien_id: current_user.id)
    end

    @lops = scope.order(:ma_lop)
  end

  def show
    @students = @lop.students.includes(:nganh).order(:ma_sv)
  end

  def new
    @lop = Lop.new
  end

  def edit; end

  def create
    @lop = Lop.new(lop_params)
    if @lop.save
      redirect_to lop_path(@lop), notice: "Tạo lớp thành công."
    else
      flash.now[:alert] = "Không thể tạo lớp."
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @lop.update(lop_params)
      redirect_to lop_path(@lop), notice: "Cập nhật lớp thành công."
    else
      flash.now[:alert] = "Không thể cập nhật lớp."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @lop.destroy
    redirect_to lops_path, notice: "Đã xoá lớp."
  end

  private

  def set_lop
    @lop = Lop.find(params[:id])
  end

  def ensure_teacher_can_see_lop!
    return unless current_user.teacher?

    if @lop.giao_vien_id.present? && @lop.giao_vien_id != current_user.id
      redirect_to lops_path, alert: "Bạn không có quyền xem lớp này."
    end
  end

  def lop_params
    params.require(:lop).permit(
      :ma_lop,
      :ten,
      :ma_khoa,
      :khoa_hoc,
      :ma_nganh,
      :ma_he_dt,
      :ma_cb,
      :ghi_chu
    )
  end

  def load_collections
    @khoa_hocs   = KhoaHoc.order(:ma_khoa)
    @nganhs      = Nganh.order(:ma_nganh)
    @he_dao_taos = HeDaoTao.order(:ma_he_dt)
  end
end
