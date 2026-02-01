#!/bin/bash

set -e

APP_NAME="Student Records Management"
DOCKER_IMAGE="tuanle03/student-records-management:latest"
CONTAINER_NAME="srm_app"
DB_CONTAINER="srm_postgres"
NETWORK_NAME="srm_network"
ENV_FILE="srm.env"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================="
echo "$APP_NAME - Quick Start"
echo -e "==========================================${NC}"

# Check Docker
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}❌ Docker chưa chạy. Vui lòng khởi động Docker Desktop!${NC}"
    echo "📥 Download: https://www.docker.com/products/docker-desktop"
    exit 1
fi

# Generate credentials if not exists
if [ ! -f "$ENV_FILE" ]; then
    echo -e "${YELLOW}🔐 Tạo credentials lần đầu...${NC}"

    SECRET_KEY=$(openssl rand -hex 64)
    DB_PASS=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-32)

    cat > "$ENV_FILE" << EOF
# Student Records Management - Environment Config
# Generated: $(date)

DB_PASSWORD=${DB_PASS}
SECRET_KEY_BASE=${SECRET_KEY}
EOF

    chmod 600 "$ENV_FILE"
    echo -e "${GREEN}✅ Đã tạo file $ENV_FILE${NC}"
    echo -e "${YELLOW}⚠️  Lưu ý: Không chia sẻ file này!${NC}"
fi

# Load environment variables
echo "🔐 Đang load cấu hình..."
export $(grep -v '^#' "$ENV_FILE" | xargs)

# Create network
if ! docker network inspect "$NETWORK_NAME" > /dev/null 2>&1; then
    echo "📡 Tạo Docker network..."
    docker network create "$NETWORK_NAME"
fi

# Check if database exists
if ! docker ps -a | grep -q "$DB_CONTAINER"; then
    echo "🗄️  Khởi tạo database container..."
    docker run -d \
        --name "$DB_CONTAINER" \
        --network "$NETWORK_NAME" \
        -e POSTGRES_DB=student_records_management_production \
        -e POSTGRES_USER=student \
        -e POSTGRES_PASSWORD="$DB_PASSWORD" \
        -v srm_postgres_data:/var/lib/postgresql/data \
        --restart unless-stopped \
        postgres:15

    echo "⏳ Chờ database khởi động..."
    sleep 10
else
    docker start "$DB_CONTAINER" > /dev/null 2>&1 || true
    echo "✅ Database container đã sẵn sàng"
fi

# Pull latest image
echo "🔄 Đang tải phiên bản mới nhất..."
docker pull "$DOCKER_IMAGE"

# Stop old app container if running
docker stop "$CONTAINER_NAME" > /dev/null 2>&1 || true
docker rm "$CONTAINER_NAME" > /dev/null 2>&1 || true

# Run app container
echo "🚀 Khởi động ứng dụng..."
docker run -d \
    --name "$CONTAINER_NAME" \
    --network "$NETWORK_NAME" \
    -e RAILS_ENV=production \
    -e DB_HOST="$DB_CONTAINER" \
    -e DB_PORT=5432 \
    -e DB_NAME=student_records_management_production \
    -e DB_USER=student \
    -e DB_PASSWORD="$DB_PASSWORD" \
    -e SECRET_KEY_BASE="$SECRET_KEY_BASE" \
    -e RAILS_LOG_TO_STDOUT=true \
    -p 0.0.0.0:8000:80 \
    --restart unless-stopped \
    "$DOCKER_IMAGE"

# Wait for app to be ready
echo "⏳ Chờ ứng dụng khởi động..."
sleep 15

# Run migrations
echo "🗄️  Chạy database migrations..."
docker exec "$CONTAINER_NAME" bin/rails db:create db:migrate 2>/dev/null || true

# Get local IP
if [[ "$OSTYPE" == "darwin"* ]]; then
    LOCAL_IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -n 1)
else
    LOCAL_IP=$(hostname -I | awk '{print $1}')
fi

echo ""
echo -e "${GREEN}=========================================="
echo "✅ Ứng dụng đã chạy thành công!"
echo -e "==========================================${NC}"
echo ""
echo "🌐 Truy cập tại:"
echo "   - Local:  http://localhost:8000"
echo "   - LAN:    http://$LOCAL_IP:8000"
echo ""
echo "📋 Lệnh quản lý:"
echo "   - Xem logs:     docker logs -f $CONTAINER_NAME"
echo "   - Dừng lại:     docker stop $CONTAINER_NAME $DB_CONTAINER"
echo "   - Khởi động:    docker start $DB_CONTAINER $CONTAINER_NAME"
echo "   - Xóa dữ liệu:  docker rm -f $CONTAINER_NAME $DB_CONTAINER && docker volume rm srm_postgres_data"
echo ""
