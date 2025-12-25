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

  # GET /students/import
  # Hiển thị form upload file CSV/XLSX cho lý lịch sinh viên.
  def import_new
    # Chỉ staff hoặc giáo viên mới được import; nếu cần hạn chế, thêm logic ở đây.
  end

  # POST /students/import
  # Xử lý file và import hồ sơ. Giáo viên chỉ import cho lớp mình chủ nhiệm.
  def import_create
    file = params[:file]
    unless file
      redirect_to import_students_path, alert: "Vui lòng chọn file để import."
      return
    end
    allowed = current_user.teacher? ? current_user.homeroom_classes.pluck(:ma_lop) : nil
    importer = HssvProfileImporter.new(file.path, allowed_classes: allowed)
    count = importer.call
    redirect_to students_path, notice: "Đã import #{count} hồ sơ sinh viên thành công."
  rescue StandardError => e
    redirect_to import_students_path, alert: "Import thất bại: #{e.message}"
  end

  # GET /students/export
  # Xuất hồ sơ sinh viên ra CSV; giáo viên chỉ xuất hồ sơ lớp mình.
  def export
    students = if current_user.teacher?
                 Hssv.where(ma_lop: current_user.homeroom_classes.select(:ma_lop))
    else
                 Hssv.all
    end
    csv_data = CSV.generate(headers: true) do |csv|
      csv << %w[MaSV HoDem Ten NgaySinh GioiTinh DienThoai DanToc TonGiao NgayDoan NgayDang
                SoCCCD QueQuan TruQuan HoTenCha NamSinhCha NgheNghiepCha NoiLamCha HoKhauCha
                HoTenMe NamSinhMe NgheNghiepMe NoiLamMe HoKhauMe HoTenVo NamSinhVo NgheNghiepVo
                NoiLamVo HoKhauVo AnhChiEm MaKhoa MaLop MaHDT MaNganh GhiChu]
      students.find_each do |s|
        csv << [
          s.ma_sv, s.ho_dem, s.ten,
          s.ngay_sinh&.strftime("%Y-%m-%d"),
          s.gioi_tinh.nil? ? nil : (s.gioi_tinh ? "Nam" : "Nữ"),
          s.dien_thoai, s.dan_toc, s.ton_giao,
          s.ngay_doan&.strftime("%Y-%m-%d"),
          s.ngay_dang&.strftime("%Y-%m-%d"),
          s.so_cmnd, s.que_quan, s.tru_quan,
          s.ho_ten_cha, s.nam_sinh_cha, s.nghe_nghiep_cha, s.noi_lam_cha, s.ho_khau_cha,
          s.ho_ten_me, s.nam_sinh_me, s.nghe_nghiep_me, s.noi_lam_me, s.ho_khau_me,
          s.ho_ten_vo, s.nam_sinh_vo, s.nghe_nghiep_vo, s.noi_lam_vo, s.ho_khau_vo,
          s.anh_chiem, s.ma_khoa, s.ma_lop, s.ma_hdt, s.ma_nganh, s.ghi_chu
        ]
      end
    end
    send_data csv_data,
              filename: "ho-so-sinh-vien-#{Time.zone.now.strftime('%Y%m%d%H%M%S')}.csv",
              type: "text/csv"
  end

  # GET /students/download_template
  # Trả về file CSV mẫu chứa duy nhất dòng tiêu đề để người dùng làm template.
  def download_template
    csv_data = CSV.generate(headers: true) do |csv|
      csv << %w[MaSV HoDem Ten NgaySinh GioiTinh DienThoai DanToc TonGiao NgayDoan NgayDang
                SoCCCD QueQuan TruQuan HoTenCha NamSinhCha NgheNghiepCha NoiLamCha HoKhauCha
                HoTenMe NamSinhMe NgheNghiepMe NoiLamMe HoKhauMe HoTenVo NamSinhVo NgheNghiepVo
                NoiLamVo HoKhauVo AnhChiEm MaKhoa MaLop MaHDT MaNganh GhiChu]
    end
    send_data csv_data, filename: "template-ho-so-sinh-vien.csv", type: "text/csv"
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
