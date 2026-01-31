# frozen_string_literal: true

ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end

    # Thống kê nhanh
    columns do
      column do
        panel "Thống kê tổng quan" do
          ul do
            li "Tổng số học viên: #{Hssv.count}"
            li "Tổng số lớp: #{Lop.count}"
            li "Tổng số môn học: #{MonHoc.count}"
            li "Tổng số giáo viên: #{User.teachers.count}"
          end
        end
      end
    end

    # Danh sách học viên gần đây
    columns do
      column do
        panel "Học viên mới nhất" do
          table_for Hssv.order(created_at: :desc).limit(5) do
            column "Mã học viên", :ma_sv
            column "Họ tên" do |student|
              "#{student.ho_dem} #{student.ten}"
            end
            column "Lớp" do |student|
              student.lop&.ten
            end
            column "Ngày tạo", :created_at
          end
        end
      end
    end
  end
end
