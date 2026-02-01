# frozen_string_literal: true

# HssvProfileImporter is responsible for importing detailed student
# personal profiles from an Excel or CSV file. The importer reads
# each row after the header, maps columns to Hssv attributes and
# creates or updates Hssv records accordingly.
#
# The expected columns in the input file are (case insensitive):
#
#   MaSV, HoDem, Ten, NgaySinh, GioiTinh, DienThoai, DanToc, TonGiao,
#   NgayDoan, NgayDang, SoCCCD, QueQuan, TruQuan,
#   HoTenCha, NamSinhCha, NgheNghiepCha, NoiLamCha, HoKhauCha,
#   HoTenMe, NamSinhMe, NgheNghiepMe, NoiLamMe, HoKhauMe,
#   HoTenVo, NamSinhVo, NgheNghiepVo, NoiLamVo, HoKhauVo,
#   AnhChiEm, MaKhoa, MaLop, MaHDT, MaNganh, GhiChu
#
# Only MaSV is mandatory. Missing optional columns will be ignored.
# Dates are parsed using Date.parse when provided as strings.
# GioiTinh is expected to be 'Nam' or 'Nữ'; other values will result
# in nil.

class HssvProfileImporter
  require "roo"

  def initialize(file_path, allowed_classes: nil)
    @file_path = file_path
    @allowed_classes = allowed_classes
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

    raise "Thiếu cột MaSV" unless header_map.key?("masv")

    processed = 0
    sheet.each_with_index do |row, index|
      next if index.zero? || row.compact.empty?

      ma_sv = cell_value(row, header_map, "masv").to_s.strip
      next if ma_sv.blank?

      malop = cell_value(row, header_map, "malop").to_s.strip if header_map.key?("malop")
      if @allowed_classes.present?
        if malop.present?
          unless @allowed_classes.include?(malop)
            raise "Dòng #{index + 1}: Mã lớp #{malop} không thuộc lớp bạn chủ nhiệm."
          end
        else
          malop = @allowed_classes.first
        end
      end

      hssv = Hssv.find_or_initialize_by(ma_sv: ma_sv)
      hssv.ho_dem      = cell_value(row, header_map, "hodem").to_s.strip if header_map.key?("hodem")
      hssv.ten         = cell_value(row, header_map, "ten").to_s.strip if header_map.key?("ten")
      hssv.ngay_sinh   = parse_date(cell_value(row, header_map, "ngaysinh")) if header_map.key?("ngaysinh")
      hssv.gioi_tinh   = parse_gender(cell_value(row, header_map, "gioitinh")) if header_map.key?("gioitinh")
      hssv.dien_thoai  = cell_value(row, header_map, "dienthoai").to_s.strip if header_map.key?("dienthoai")
      hssv.dan_toc     = cell_value(row, header_map, "dantoc").to_s.strip if header_map.key?("dantoc")
      hssv.ton_giao    = cell_value(row, header_map, "tongiao").to_s.strip if header_map.key?("tongiao")
      hssv.ngay_doan   = parse_date(cell_value(row, header_map, "ngaydoan")) if header_map.key?("ngaydoan")
      hssv.ngay_dang   = parse_date(cell_value(row, header_map, "ngaydang")) if header_map.key?("ngaydang")
      hssv.so_cmnd     = cell_value(row, header_map, "socccd").to_s.strip if header_map.key?("socccd")
      hssv.que_quan    = cell_value(row, header_map, "quequan").to_s.strip if header_map.key?("quequan")
      hssv.tru_quan    = cell_value(row, header_map, "truquan").to_s.strip if header_map.key?("truquan")
      hssv.ho_ten_cha  = cell_value(row, header_map, "hotencha").to_s.strip if header_map.key?("hotencha")
      hssv.nam_sinh_cha = parse_year(cell_value(row, header_map, "namsinhcha")) if header_map.key?("namsinhcha")
      hssv.nghe_nghiep_cha = cell_value(row, header_map, "nghenghiepcha").to_s.strip if header_map.key?("nghenghiepcha")
      hssv.noi_lam_cha = cell_value(row, header_map, "noilamcha").to_s.strip if header_map.key?("noilamcha")
      hssv.ho_khau_cha = cell_value(row, header_map, "hokhaucha").to_s.strip if header_map.key?("hokhaucha")
      hssv.ho_ten_me   = cell_value(row, header_map, "hotenme").to_s.strip if header_map.key?("hotenme")
      hssv.nam_sinh_me = parse_year(cell_value(row, header_map, "namsinhme")) if header_map.key?("namsinhme")
      hssv.nghe_nghiep_me = cell_value(row, header_map, "nghenghiepme").to_s.strip if header_map.key?("nghenghiepme")
      hssv.noi_lam_me  = cell_value(row, header_map, "noilamme").to_s.strip if header_map.key?("noilamme")
      hssv.ho_khau_me  = cell_value(row, header_map, "hokhaume").to_s.strip if header_map.key?("hokhaume")
      hssv.ho_ten_vo   = cell_value(row, header_map, "hotenvo").to_s.strip if header_map.key?("hotenvo")
      hssv.nam_sinh_vo = parse_year(cell_value(row, header_map, "namsinhvo")) if header_map.key?("namsinhvo")
      hssv.nghe_nghiep_vo = cell_value(row, header_map, "nghenghiepvo").to_s.strip if header_map.key?("nghenghiepvo")
      hssv.noi_lam_vo  = cell_value(row, header_map, "noilamvo").to_s.strip if header_map.key?("noilamvo")
      hssv.ho_khau_vo  = cell_value(row, header_map, "hokhauvo").to_s.strip if header_map.key?("hokhauvo")
      hssv.anh_chiem   = cell_value(row, header_map, "anhchiem").to_s.strip if header_map.key?("anhchiem")
      hssv.ma_khoa     = cell_value(row, header_map, "makhoa").to_s.strip if header_map.key?("makhoa")
      hssv.ma_lop      = malop if malop.present?
      hssv.ma_hdt      = cell_value(row, header_map, "mahdt").to_s.strip if header_map.key?("mahdt")
      hssv.ma_nganh    = cell_value(row, header_map, "manganh").to_s.strip if header_map.key?("manganh")
      hssv.ghi_chu     = cell_value(row, header_map, "ghichu").to_s.strip if header_map.key?("ghichu")

      hssv.save!
      processed += 1
    end
    processed
  end

  private

  def cell_value(row, header_map, key)
    index = header_map[key]
    return nil unless index
    val = row[index]
    val.respond_to?(:cell_value) ? val.cell_value : val
  end

  # Convert gender text to boolean. Returns true for 'Nam', false for 'Nữ', nil otherwise.
  def parse_gender(value)
    return nil if value.blank?
    str = value.to_s.strip.downcase
    return true  if str == "nam"
    return false if str == "nữ" || str == "nu"
    nil
  end

  # Parse date strings into Date objects. Returns nil if parsing fails.
  def parse_date(value)
    return nil if value.blank?
    return value if value.is_a?(Date)
    Date.parse(value.to_s) rescue nil
  end

  # Parse year strings into Date objects. Returns nil for blanks or non-numeric values.
  def parse_year(value)
    return nil if value.blank?
    val_str = value.to_s.strip
    return nil unless val_str =~ /\A\d{4}\z/
    year = val_str.to_i
    Date.new(year, 1, 1) rescue nil
  end
end
