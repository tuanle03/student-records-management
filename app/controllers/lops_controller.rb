class LopsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lop, only: %i[show edit update destroy]
  before_action :load_collections, only: %i[new edit create update]

  def index
    @q = params[:q]
    @lops = Lop.includes(:khoa_hoc, :nganh, :he_dao_tao)
               .then { |scope|
                  if @q.present?
                    scope.where("ma_lop ILIKE :q OR ten ILIKE :q", q: "%#{ActiveRecord::Base.sanitize_sql_like(@q)}%")
                  else
                    scope
                  end
                }
                .order(:ma_lop)
  end

  def show
    @students = @lop.hssvs.includes(:khoa_hoc, :nganh, :he_dao_tao).order(:ma_sv)
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
