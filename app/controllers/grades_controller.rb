# frozen_string_literal: true

class GradesController < ApplicationController
  require "csv"
  before_action :authenticate_user!
  before_action :set_subject, only: [ :show ]

  # GET /grades
  # Display a list of all subjects with quick links to view grades,
  # export scores and import new scores.
  def index
    @subjects = MonHoc.order(:ma_mon_hoc)
  end

  # GET /grades/:id
  # Show grade table for a specific subject. Teachers will only see
  # students in their homeroom classes; staff see all students.
  def show
    # Fetch all DiemHocTap records for this subject
    @grades = DiemHocTap.includes(:hssv).where(ma_mon_hoc: @subject.ma_mon_hoc)
    if current_user.teacher?
      allowed_classes = current_user.homeroom_classes.select(:ma_lop)
      @grades = @grades.where(ma_sv: Hssv.where(ma_lop: allowed_classes).select(:ma_sv))
    end
    @grades = @grades.order(:ma_sv)
  end

  # GET /grades/import
  # Render form to upload a file of exam scores. Optionally the user
  # can provide a default academic term (ma_hoc_ky) that will be applied
  # to all rows if not specified in the file.
  def import_new
    @default_hoc_ky = params[:default_hoc_ky]
  end

  # POST /grades/import
  # Process the uploaded file and import exam scores. Expects params[:file]
  # to be an uploaded file. Optional params[:default_hoc_ky] will be
  # passed to the importer if provided.
  def import_create
    file = params[:file]
    unless file
      redirect_to import_grades_path, alert: "Vui lòng chọn file để import."
      return
    end

    default_hoc_ky = params[:default_hoc_ky].presence
    importer = DiemHocTapImporter.new(
      file.path,
      default_hoc_ky: default_hoc_ky,
      current_user: current_user
    )

    count = importer.call

    warning_message = build_import_warning(importer)

    redirect_to grades_path,
      notice: "Đã import #{count} bản ghi điểm học tập thành công.",
      alert: warning_message
  rescue StandardError => e
    redirect_to import_grades_path, alert: "Import thất bại: #{e.message}"
  end

  # GET /grades/export
  # Export all grade records into a CSV file. Teachers only export
  # records for students in their classes. Staff exports everything.
  def export
    grades = DiemHocTap.includes(:hssv)
    if current_user.teacher?
      allowed_classes = current_user.homeroom_classes.select(:ma_lop)
      grades = grades.where(ma_sv: Hssv.where(ma_lop: allowed_classes).select(:ma_sv))
    end

    csv_data = CSV.generate(headers: true) do |csv|
      csv << [ "MaSV", "HoDem", "Ten", "MaMonHoc", "MaHocKy", "DiemBP", "DiemKTHP", "DiemDGHP", "DiemThiLaiLan1", "DiemThiLaiLan2" ]
      grades.find_each do |grade|
        student = grade.hssv
        csv << [
          grade.ma_sv,
          student&.ho_dem,
          student&.ten,
          grade.ma_mon_hoc,
          grade.ma_hoc_ky,
          grade.diem_gp,
          grade.diem_hp,
          grade.tinh_diem_tb,
          grade.diem_thi_lai_lan1,
          grade.diem_thi_lai_lan2
        ]
      end
    end
    send_data csv_data, filename: "grades-#{Time.zone.now.strftime('%Y%m%d%H%M%S')}.csv", type: "text/csv"
  end

  # GET /grades/download_template
  # Provide a CSV template for importing exam scores. The template
  # contains the required headers with no data rows.
  def download_template
    csv_data = CSV.generate(headers: true) do |csv|
      csv << [ "MaSV", "HoDem", "Ten", "MaMonHoc", "MaHocKy", "DiemBP", "DiemKTHP", "DiemDGHP", "DiemThiLaiLan1", "DiemThiLaiLan2" ]
    end
    send_data csv_data, filename: "template-diem-hoc-tap.csv", type: "text/csv"
  end

  private

  def set_subject
    @subject = MonHoc.find_by!(ma_mon_hoc: params[:id])
  end

  def build_import_warning(importer)
    return nil if importer.warnings.blank?

    preview = importer.warnings.first(10).join(" | ")
    more = importer.warnings.size > 10 ? " | ... (#{importer.warnings.size - 10} dòng khác)" : ""

    "Có #{importer.skipped_count} dòng bị bỏ qua do học viên không thuộc lớp chủ nhiệm. Chi tiết: #{preview}#{more}"
  end
end
