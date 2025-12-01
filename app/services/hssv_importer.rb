class HssvImporter
  require "roo"

  def initialize(file_path)
    @file_path = file_path
  end

  # mapping cột Excel -> thuộc tính model
  def call
    xlsx = Roo::Spreadsheet.open(@file_path)
    sheet = xlsx.sheet(0)

    # giả sử dòng 1 là header
    sheet.each_row_streaming(offset: 1) do |row|
      ma_sv   = row[0].cell_value.to_s.strip
      ho_dem  = row[1].cell_value.to_s.strip
      ten     = row[2].cell_value.to_s.strip
      ma_lop  = row[3].cell_value.to_s.strip
      ma_khoa = row[4].cell_value.to_s.strip

      next if ma_sv.blank?

      Hssv.find_or_initialize_by(ma_sv: ma_sv).tap do |s|
        s.ho_dem  = ho_dem
        s.ten     = ten
        s.ma_lop  = ma_lop
        s.ma_khoa = ma_khoa
        # ... map thêm các cột cần thiết
        s.save!
      end
    end
  end
end
