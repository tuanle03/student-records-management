class StudentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_student, only: %i[show edit update destroy]
  before_action :load_collections, only: %i[new edit create update]
  before_action :authorize_teacher_for_student!, only: %i[show edit update destroy]
  before_action :authorize_teacher_for_create!, only: %i[new create]

  def index
    @q = params[:q]

    scope = Hssv.includes(:lop, :nganh)

    if current_user.teacher?
      lop_codes = current_user.homeroom_classes.select(:ma_lop)
      scope = scope.where(ma_lop: lop_codes)
    end

    @students = scope.search(@q).order(:ma_sv)
  end

  def show
  end

  def new
    @student = Hssv.new
  end

  def edit
  end

  def create
    @student = Hssv.new(student_params)

    if @student.save
      redirect_to student_path(@student),
                  notice: "Tạo sinh viên thành công."
    else
      flash.now[:alert] = "Không thể tạo sinh viên. Vui lòng kiểm tra lại."
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @student.update(student_params)
      redirect_to student_path(@student),
                  notice: "Cập nhật sinh viên thành công."
    else
      flash.now[:alert] = "Không thể cập nhật sinh viên. Vui lòng kiểm tra lại."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @student.destroy
    redirect_to students_path, notice: "Đã xoá sinh viên."
  end

  private

  def set_student
    @student = Hssv.find_by!(ma_sv: params[:ma_sv])
  end

  def authorize_teacher_for_student!
    return unless current_user.teacher?
    if @student.lop&.giao_vien_id != current_user.id
      redirect_to students_path, alert: "Bạn không có quyền thao tác với sinh viên này."
    end
  end

  def authorize_teacher_for_create!
    return unless current_user.teacher?
    if params[:hssv] && params[:hssv][:ma_lop].present?
      allowed = current_user.homeroom_classes.pluck(:ma_lop)
      unless allowed.include?(params[:hssv][:ma_lop])
        redirect_to students_path, alert: "Bạn chỉ có thể thêm sinh viên vào lớp bạn chủ nhiệm."
      end
    end
  end

  def load_collections
    if current_user.teacher?
      @lops = current_user.homeroom_classes.order(:ma_lop)
    else
      @lops = Lop.order(:ma_lop)
    end
    @nganhs      = Nganh.order(:ma_nganh)
    @khoa_hocs   = KhoaHoc.order(:ma_khoa)
    @he_dao_taos = HeDaoTao.order(:ma_he_dt)
  end

  def student_params
    params.require(:hssv).permit(
      :ma_sv, :ho_dem, :ten, :ngay_sinh, :gioi_tinh, :anh, :ma_huyen, :dien_thoai, :dan_toc,
      :ton_giao, :khu_vuc, :doi_tuong, :ngay_doan, :ngay_dang, :so_cmnd, :ngay_cmnd, :noi_cmnd,
      :que_quan, :tru_quan, :ktk_l, :tom_tat_qtct, :ho_ten_cha, :nam_sinh_cha, :nghe_nghiep_cha,
      :noi_lam_cha, :ho_khau_cha, :ho_ten_me, :nam_sinh_me, :nghe_nghiep_me, :noi_lam_me, :ho_khau_me,
      :ho_ten_vo, :nam_sinh_vo, :nghe_nghiep_vo, :noi_lam_vo, :ho_khau_vo, :anh_chiem, :ma_lop, :ma_khoa,
      :ma_hdt, :ma_nganh, :ghi_chu
    )
  end
end
