class LopsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lop, only: :show

  def index
    @lops = Lop.includes(:khoa_hoc, :nganh, :he_dao_tao).order(:ten)
  end

  def show
    @students = Hssv.where(ma_lop: @lop.ma_lop).order(:ma_sv)
  end

  private

  def set_lop
    @lop = Lop.find_by!(ma_lop: params[:id])
  end
end
