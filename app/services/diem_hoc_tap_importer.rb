# frozen_string_literal: true

# DiemHocTapImporter is responsible for importing exam score data
# from an Excel or CSV file. The importer expects a header row and then
# parses each subsequent row. It creates or updates a DiemHocTap
# record for each row based on student code (ma_sv), subject code
# (ma_mon_hoc) and academic term (ma_hoc_ky). If a record already
# exists for the given ma_sv, ma_mon_hoc and ma_hoc_ky combination
# it will be updated; otherwise a new record will be created.
#
# The expected columns in the input file are (case insensitive):
#
#   - MaSV:        Student code (ma_sv)
#   - MaMonHoc:    Subject code (ma_mon_hoc)
#   - MaHocKy:     Academic term/semester code (ma_hoc_ky)
#   - Diem BP:     Exam score (diem_gp)
#   - Diem KTHP:   Exam score (diem_hp)
#   - Diem ĐGHP:   Average score (optional – if blank it will be
#                  automatically computed based on diem_gp and diem_hp)
#   - DiemThiLaiLan1: Score for the first retake exam (optional)
#   - DiemThiLaiLan2: Score for the second retake exam (optional)
#
# Additional columns such as HoDem or Ten may be present in the file
# but are ignored by the importer. They are kept in the sample file
# to guide users but do not affect import.

class DiemHocTapImporter
  require "roo"
  require "set"

  attr_reader :warnings, :skipped_count

  def initialize(file_path, default_hoc_ky: nil, current_user: nil)
    @file_path      = file_path
    @default_hoc_ky = default_hoc_ky
    @current_user   = current_user

    @warnings = []
    @skipped_count = 0

    @allowed_student_codes = build_allowed_student_codes
  end

  def call
    spreadsheet = Roo::Spreadsheet.open(@file_path)
    sheet = spreadsheet.sheet(0)
    header = sheet.row(1).map { |h| h.to_s.strip }

    header_map = {}
    header.each_with_index do |col, idx|
      normalized = col.to_s.strip.downcase
      header_map[normalized] = idx
    end

    required_cols = %w[masv mamonhoc]
    missing = required_cols - header_map.keys
    raise "Missing required columns: #{missing.join(', ')}" if missing.any?

    if !header_map.key?("mahocky") && @default_hoc_ky.blank?
      raise "Thiếu cột MaHocKy trong file và bạn chưa nhập Học kỳ mặc định (default_hoc_ky)."
    end

    processed = 0

    sheet.each_with_index do |row, index|
      next if index.zero?
      next if row.compact.empty?

      ma_sv      = cell_value(row, header_map, "masv").to_s.strip
      ma_mon_hoc = cell_value(row, header_map, "mamonhoc").to_s.strip
      next if ma_sv.blank? || ma_mon_hoc.blank?

      unless allowed_student?(ma_sv)
        @skipped_count += 1
        @warnings << "Dòng #{index + 1}: MaSV #{ma_sv} không thuộc lớp chủ nhiệm, bỏ qua (không nhập điểm)."
        next
      end

      ma_hoc_ky  = cell_value(row, header_map, "mahocky").to_s.strip
      ma_hoc_ky  = @default_hoc_ky if ma_hoc_ky.blank?

      if ma_hoc_ky.blank?
        raise "Dòng #{index + 1}: MaHocKy trống. Vui lòng điền MaHocKy trong file hoặc nhập Học kỳ mặc định."
      end

      diem_gp    = numeric_or_nil(cell_value(row, header_map, "diem bp"))
      diem_hp    = numeric_or_nil(cell_value(row, header_map, "diem kthp"))
      diem_tb    = numeric_or_nil(cell_value(row, header_map, "diem đghp"))
      diem_thi_lai_lan1 = numeric_or_nil(cell_value(row, header_map, "diemthilailan1"))
      diem_thi_lai_lan2 = numeric_or_nil(cell_value(row, header_map, "diemthilailan2"))

      record = DiemHocTap.find_or_initialize_by(
        ma_sv: ma_sv,
        ma_mon_hoc: ma_mon_hoc,
        ma_hoc_ky: ma_hoc_ky
      )

      record.diem_gp           = diem_gp
      record.diem_hp           = diem_hp
      record.diem_tb           = diem_tb
      record.diem_thi_lai_lan1 = diem_thi_lai_lan1
      record.diem_thi_lai_lan2 = diem_thi_lai_lan2

      record.save!
      processed += 1
    end

    processed
  end

  private

  def build_allowed_student_codes
    return nil unless @current_user&.teacher?

    allowed_classes = @current_user.homeroom_classes.select(:ma_lop)
    Set.new(Hssv.where(ma_lop: allowed_classes).pluck(:ma_sv))
  end

  def allowed_student?(ma_sv)
    return true unless @current_user&.teacher?
    @allowed_student_codes.include?(ma_sv)
  end

  def cell_value(row, header_map, key)
    index = header_map[key]
    return nil unless index
    cell = row[index]
    cell.respond_to?(:cell_value) ? cell.cell_value : cell
  end

  def numeric_or_nil(value)
    return nil if value.blank?
    Float(value)
  rescue StandardError
    nil
  end
end
