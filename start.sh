#!/bin/bash

# Student Records Management - Startup Script for macOS/Linux
# This script starts the application with Docker Compose and opens it to LAN

set -e

echo "🎓 Student Records Management - Starting..."
echo "=============================================="

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get local IP address
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    LOCAL_IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -n 1)
else
    # Linux
    LOCAL_IP=$(hostname -I | awk '{print $1}')
fi

echo -e "${YELLOW}📡 Local IP Address: ${LOCAL_IP}${NC}"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker Desktop first."
    exit 1
fi

# Stop any existing containers
echo "🛑 Stopping existing containers..."
docker-compose down 2>/dev/null || true

# Build and start services
echo "🏗️  Building and starting services..."
docker-compose up -d --build

# Wait for database to be ready
echo "⏳ Waiting for database to be ready..."
sleep 10

# Run database migrations
echo "🗄️  Running database migrations..."
docker-compose exec -T web bin/rails db:create db:migrate 2>/dev/null || true

echo ""
echo -e "${GREEN}✅ Application is running!${NC}"
echo "=============================================="
echo -e "🌐 Local access:    http://localhost:8000"
echo -e "📱 LAN access:      http://${LOCAL_IP}:8000"
echo "=============================================="
echo ""
echo "📋 Useful commands:"
echo "  - View logs:        docker-compose logs -f"
echo "  - Stop app:         docker-compose down"
echo "  - Restart:          docker-compose restart"
echo "  - Shell access:     docker-compose exec web bash"
echo ""
echo "🔍 Press Ctrl+C to view logs (app keeps running in background)"
echo ""

# Follow logs
docker-compose logs -f
