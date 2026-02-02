#!/bin/bash

# Script tự động khởi động ứng dụng Quản Lý Thông Tin Học Viên với host tùy chỉnh qlhv.local
# Người dùng chỉ cần chạy file này, tất cả sẽ được thực hiện tự động.

set -e

# Cấu hình ứng dụng
TEN_UNG_DUNG="Quản Lý Thông Tin Học Viên"
HINH_ANH_DOCKER="tuanle03/student-records-management:latest"
TEN_CONTAINER_UNG_DUNG="qlhv_ung_dung"
TEN_CONTAINER_DB="qlhv_postgres"
TEN_MANG="qlhv_mang"
FILE_ENV=".env"
FILE_ENV_PHU="qlhv.env"
HOST_TUY_CHINH="qlhv.local"
PORT_UNG_DUNG=8000

# Màu sắc cho đầu ra
DO='\033[0;31m'
XANH_LA='\033[0;32m'
VANG='\033[1;33m'
XANH_DUONG='\033[0;34m'
KHONG_MAU='\033[0m'

echo -e "${XANH_DUONG}=========================================="
echo "$TEN_UNG_DUNG - Khởi Động Nhanh"
echo -e "==========================================${KHONG_MAU}"

# Bước 1: Kiểm tra Docker
echo "🔍 Đang kiểm tra Docker..."
if ! docker info > /dev/null 2>&1; then
    echo -e "${DO}❌ Lỗi: Docker chưa chạy. Vui lòng khởi động Docker Desktop trước!${KHONG_MAU}"
    echo "📥 Tải Docker tại: https://www.docker.com/products/docker-desktop"
    exit 1
fi
echo -e "${XANH_LA}✅ Docker đã sẵn sàng!${KHONG_MAU}"

# Bước 2: Tự động thêm host tùy chỉnh vào /etc/hosts
echo "🌐 Đang cấu hình host tùy chỉnh '$HOST_TUY_CHINH'..."
if ! grep -q "$HOST_TUY_CHINH" /etc/hosts; then
    echo "127.0.0.1 $HOST_TUY_CHINH" | sudo tee -a /etc/hosts > /dev/null
    echo -e "${XANH_LA}✅ Đã thêm '$HOST_TUY_CHINH' vào /etc/hosts!${KHONG_MAU}"
else
    echo -e "${VANG}⚠️  Host '$HOST_TUY_CHINH' đã tồn tại trong /etc/hosts.${KHONG_MAU}"
fi

# Bước 3: Tải biến môi trường
if [ -f "$FILE_ENV" ]; then
    echo -e "${XANH_LA}🔐 Đang tải cấu hình từ $FILE_ENV...${KHONG_MAU}"
    export $(grep -v '^#' "$FILE_ENV" | xargs)
elif [ -f "$FILE_ENV_PHU" ]; then
    echo -e "${XANH_LA}🔐 Đang tải cấu hình từ $FILE_ENV_PHU...${KHONG_MAU}"
    export $(grep -v '^#' "$FILE_ENV_PHU" | xargs)
else
    echo -e "${VANG}🔐 Không tìm thấy file .env, đang tạo $FILE_ENV_PHU lần đầu...${KHONG_MAU}"

    DB_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-32)
    SECRET_KEY_BASE=$(openssl rand -hex 64)

    cat > "$FILE_ENV_PHU" << EOF
# Quản Lý Hồ Sơ Sinh Viên - Cấu Hình Môi Trường
# Tạo ngày: $(date)

DB_PASSWORD=${DB_PASSWORD}
SECRET_KEY_BASE=${SECRET_KEY_BASE}
EOF

    chmod 600 "$FILE_ENV_PHU"
    echo -e "${XANH_LA}✅ Đã tạo file $FILE_ENV_PHU${KHONG_MAU}"
    echo -e "${VANG}⚠️  Lưu ý: Không chia sẻ file này!${KHONG_MAU}"
    echo -e "${XANH_DUONG}💡 Mẹo: Tạo file .env để dùng mật khẩu tùy chỉnh${KHONG_MAU}"

    export $(grep -v '^#' "$FILE_ENV_PHU" | xargs)
fi

# Bước 4: Xác minh biến cần thiết
if [ -z "$DB_PASSWORD" ] || [ -z "$SECRET_KEY_BASE" ]; then
    echo -e "${DO}❌ Lỗi: Thiếu DB_PASSWORD hoặc SECRET_KEY_BASE trong file env${KHONG_MAU}"
    exit 1
fi
echo -e "${XANH_LA}✅ Cấu hình môi trường đã sẵn sàng!${KHONG_MAU}"

# Bước 5: Tạo mạng Docker
if ! docker network inspect "$TEN_MANG" > /dev/null 2>&1; then
    echo "📡 Đang tạo mạng Docker..."
    docker network create "$TEN_MANG"
    echo -e "${XANH_LA}✅ Đã tạo mạng '$TEN_MANG'!${KHONG_MAU}"
fi

# Bước 6: Khởi tạo container database
if ! docker ps -a | grep -q "$TEN_CONTAINER_DB"; then
    echo "🗄️  Đang khởi tạo container database..."
    docker run -d \
        --name "$TEN_CONTAINER_DB" \
        --network "$TEN_MANG" \
        -e POSTGRES_DB=student_records_management_production \
        -e POSTGRES_USER=student \
        -e POSTGRES_PASSWORD="$DB_PASSWORD" \
        -v qlhv_postgres_data:/var/lib/postgresql/data \
        --restart unless-stopped \
        postgres:15

    echo "⏳ Đang chờ database khởi động..."
    sleep 10
    echo -e "${XANH_LA}✅ Database đã sẵn sàng!${KHONG_MAU}"
else
    docker start "$TEN_CONTAINER_DB" > /dev/null 2>&1 || true
    echo -e "${XANH_LA}✅ Container database đã tồn tại và đang chạy!${KHONG_MAU}"
fi

# Bước 7: Tải hình ảnh Docker mới nhất
echo "🔄 Đang tải phiên bản ứng dụng mới nhất..."
docker pull "$HINH_ANH_DOCKER"
echo -e "${XANH_LA}✅ Đã tải xong!${KHONG_MAU}"

# Bước 8: Dừng và xóa container ứng dụng cũ
docker stop "$TEN_CONTAINER_UNG_DUNG" > /dev/null 2>&1 || true
docker rm "$TEN_CONTAINER_UNG_DUNG" > /dev/null 2>&1 || true

# Bước 9: Khởi động container ứng dụng
echo "🚀 Đang khởi động ứng dụng trên host '$HOST_TUY_CHINH'..."
docker run -d \
    --name "$TEN_CONTAINER_UNG_DUNG" \
    --network "$TEN_MANG" \
    -e RAILS_ENV=production \
    -e DB_HOST="$TEN_CONTAINER_DB" \
    -e DB_PORT=5432 \
    -e DB_NAME=student_records_management_production \
    -e DB_USER=student \
    -e DB_PASSWORD="$DB_PASSWORD" \
    -e SECRET_KEY_BASE="$SECRET_KEY_BASE" \
    -e RAILS_LOG_TO_STDOUT=true \
    -p 127.0.0.1:$PORT_UNG_DUNG:80 \
    --restart unless-stopped \
    "$HINH_ANH_DOCKER"

# Bước 10: Chờ ứng dụng khởi động
echo "⏳ Đang chờ ứng dụng khởi động..."
sleep 15

# Bước 11: Chạy migration database
echo "🗄️  Đang chạy migration database..."
docker exec "$TEN_CONTAINER_UNG_DUNG" bin/rails db:create db:migrate 2>/dev/null || true
echo -e "${XANH_LA}✅ Migration hoàn thành!${KHONG_MAU}"

# Bước 12: Hiển thị thông tin truy cập
echo ""
echo -e "${XANH_LA}=========================================="
echo "✅ Ứng dụng đã chạy thành công trên host tùy chỉnh!"
echo -e "==========================================${KHONG_MAU}"
echo ""
echo "🌐 Truy cập tại:"
echo "   - Host tùy chỉnh (LAN): http://$HOST_TUY_CHINH:$PORT_UNG_DUNG"
echo "   - Local               : http://localhost:$PORT_UNG_DUNG"
echo ""
echo "📋 Lệnh quản lý:"
echo "   - Xem logs:       docker logs -f $TEN_CONTAINER_UNG_DUNG"
echo "   - Dừng lại:       docker stop $TEN_CONTAINER_UNG_DUNG $TEN_CONTAINER_DB"
echo "   - Khởi động lại:  docker start $TEN_CONTAINER_DB $TEN_CONTAINER_UNG_DUNG"
echo "   - Xóa dữ liệu:    docker rm -f $TEN_CONTAINER_UNG_DUNG $TEN_CONTAINER_DB && docker volume rm qlhv_postgres_data"
echo ""
echo -e "${XANH_DUONG}🎉 Hoàn thành! Chỉ cần mở trình duyệt và truy cập http://$HOST_TUY_CHINH:$PORT_UNG_DUNG${KHONG_MAU}"
