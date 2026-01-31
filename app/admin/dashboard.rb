# frozen_string_literal: true

ActiveAdmin.register_page "Dashboard" do
  menu label: "Bảng điều khiển", priority: 0

  content title: proc { I18n.t("active_admin.dashboard") } do
    div class: "bg-gradient-to-br from-slate-900 via-slate-800 to-slate-900 p-6 rounded-3xl shadow-2xl shadow-slate-900/60" do
      span class: "text-blue-300 text-xl font-bold" do
        "Chào mừng đến với Hệ thống quản lý hồ sơ sinh viên"
      end
      small class: "text-slate-400 block mt-2" do
        "Sử dụng menu bên trái để quản lý học viên, lớp, điểm số và các chức năng khác."
      end
    end

    columns do
      column do
        panel "Thống kê nhanh", class: "bg-slate-800/90 backdrop-blur-sm border border-slate-700 rounded-3xl shadow-xl p-6" do
          ul class: "space-y-2 text-slate-300" do
            li "Tổng số học viên: #{Hssv.count}"
            li "Tổng số lớp: #{Lop.count}"
            li "Tổng số môn học: #{MonHoc.count}"
            li "Tổng số giáo viên: #{User.count}"
          end
        end
      end

      column do
        panel "Học viên mới nhất", class: "bg-slate-800/90 backdrop-blur-sm border border-slate-700 rounded-3xl shadow-xl p-6" do
          ul class: "space-y-2" do
            Hssv.order(created_at: :desc).limit(5).map do |s|
              li link_to("#{s.ma_sv} - #{s.ho_dem} #{s.ten}", admin_hssv_path(s), class: "text-blue-400 hover:text-blue-300 transition")
            end
          end
        end
      end
    end
  end
end
