#!/bin/bash

# Student Records Management - One-Click Deployment
# Auto-generates secrets for security

set -e

APP_NAME="Student Records Management"
DOCKER_IMAGE="tuanle03/student-records-management:latest"
COMPOSE_FILE="docker-compose.production.yml"
ENV_FILE=".env"

echo "🎓 $APP_NAME - Auto Update & Deploy"
echo "=========================================="

# Check Docker
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please install/start Docker Desktop first."
    echo "📥 Download: https://www.docker.com/products/docker-desktop"
    exit 1
fi

# Download latest docker-compose file if not exists
if [ ! -f "$COMPOSE_FILE" ]; then
    echo "📥 Downloading configuration file..."
    curl -sL https://raw.githubusercontent.com/tuanle03/student-records-management/main/docker-compose.production.yml -o $COMPOSE_FILE
fi

# Create .env file if not exists
if [ ! -f "$ENV_FILE" ]; then
    echo "🔐 Generating secure credentials..."

    # Generate secure random keys
    SECRET_KEY_BASE=$(openssl rand -hex 64)
    DB_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-25)

    cat > $ENV_FILE << EOF
# Auto-generated configuration - DO NOT SHARE THIS FILE
# Generated on: $(date)

# Database Configuration
DB_PASSWORD=${DB_PASSWORD}

# Rails Secret Key (DO NOT CHANGE after first deployment)
SECRET_KEY_BASE=${SECRET_KEY_BASE}

# Optional: Uncomment to use custom master key
# RAILS_MASTER_KEY=your_key_here

# Optional: Custom port
# APP_PORT=8000
EOF

    echo "✅ Credentials generated and saved to .env"
    echo "⚠️  IMPORTANT: Keep .env file secure - do not share it!"
else
    echo "✅ Using existing credentials from .env"
fi

# Pull latest image
echo "🔄 Checking for updates..."
docker pull $DOCKER_IMAGE

# Stop old containers
echo "🛑 Stopping old version..."
docker-compose -f $COMPOSE_FILE down 2>/dev/null || true

# Start new version
echo "🚀 Starting latest version..."
docker-compose -f $COMPOSE_FILE up -d

# Wait for services
echo "⏳ Waiting for services to start..."
sleep 15

# Run migrations
echo "🗄️  Setting up database..."
docker-compose -f $COMPOSE_FILE exec -T web bin/rails db:create 2>/dev/null || true
docker-compose -f $COMPOSE_FILE exec -T web bin/rails db:migrate 2>/dev/null || true

# Seed data (optional, comment out if not needed)
# docker-compose -f $COMPOSE_FILE exec -T web bin/rails db:seed 2>/dev/null || true

# Get IP
if [[ "$OSTYPE" == "darwin"* ]]; then
    LOCAL_IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -n 1)
else
    LOCAL_IP=$(hostname -I | awk '{print $1}')
fi

echo ""
echo "=========================================="
echo "✅ Deployment completed successfully!"
echo "=========================================="
echo "🌐 Access the application at:"
echo "   Local:  http://localhost:8000"
echo "   LAN:    http://$LOCAL_IP:8000"
echo "=========================================="
echo ""
echo "📋 Useful commands:"
echo "  View logs:     docker-compose -f $COMPOSE_FILE logs -f"
echo "  Stop app:      docker-compose -f $COMPOSE_FILE down"
echo "  Restart:       docker-compose -f $COMPOSE_FILE restart"
echo ""
