#!/bin/bash

# Student Records Management - One-Click Deployment
# Fully automated with database password sync fix

set -e

APP_NAME="Student Records Management"
DOCKER_IMAGE="tuanle03/student-records-management:latest"
COMPOSE_FILE="docker-compose.production.yml"
ENV_FILE=".env"

echo "🎓 $APP_NAME - Auto Update & Deploy"
echo "=========================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check Docker
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}❌ Docker is not running. Please install/start Docker Desktop first.${NC}"
    echo "📥 Download: https://www.docker.com/products/docker-desktop"
    exit 1
fi

# Download latest docker-compose file if not exists
if [ ! -f "$COMPOSE_FILE" ]; then
    echo "📥 Downloading configuration file..."
    curl -sL https://raw.githubusercontent.com/tuanle03/student-records-management/main/docker-compose.production.yml -o $COMPOSE_FILE
fi

# Check if .env exists and containers are running
ENV_EXISTS=false
CONTAINERS_RUNNING=false

if [ -f "$ENV_FILE" ]; then
    ENV_EXISTS=true
    echo "✅ Found existing .env file"
fi

if docker ps | grep -q student_records_db; then
    CONTAINERS_RUNNING=true
    echo "⚠️  Containers are already running"
fi

# Handle environment setup
if [ "$ENV_EXISTS" = false ]; then
    echo "🔐 Generating new secure credentials..."

    # Generate secure random keys
    SECRET_KEY_BASE=$(openssl rand -hex 64)
    DB_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-25)

    # Create .env file
    cat > $ENV_FILE << EOF
# Auto-generated configuration - DO NOT SHARE THIS FILE
# Generated on: $(date)

# Database Configuration
DB_PASSWORD=${DB_PASSWORD}

# Rails Secret Key (DO NOT CHANGE after first deployment)
SECRET_KEY_BASE=${SECRET_KEY_BASE}

# Optional: Uncomment to use custom master key
# RAILS_MASTER_KEY=

# Optional: Custom port
# APP_PORT=8000
EOF

    echo -e "${GREEN}✅ Credentials generated and saved to .env${NC}"
    echo -e "${YELLOW}⚠️  IMPORTANT: Keep .env file secure - do not share it!${NC}"

    # If containers are running with old config, we MUST reset them
    if [ "$CONTAINERS_RUNNING" = true ]; then
        echo -e "${YELLOW}⚠️  New credentials generated but containers are running with old config${NC}"
        echo -e "${YELLOW}🔄 Need to recreate containers with new credentials...${NC}"
        docker-compose -f $COMPOSE_FILE down -v 2>/dev/null || true
        echo "✅ Old containers removed"
    fi
else
    echo "✅ Using existing credentials from .env"
fi

# Load .env and export all variables for docker-compose
echo "🔐 Loading environment configuration..."
set -a  # automatically export all variables
source $ENV_FILE
set +a  # stop automatically exporting

# Verify required variables are set
if [ -z "$SECRET_KEY_BASE" ]; then
    echo -e "${RED}❌ ERROR: SECRET_KEY_BASE is not set in .env${NC}"
    exit 1
fi

if [ -z "$DB_PASSWORD" ]; then
    echo -e "${RED}❌ ERROR: DB_PASSWORD is not set in .env${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Environment variables loaded successfully${NC}"
echo "   DB_PASSWORD: ${DB_PASSWORD:0:5}... (hidden)"
echo "   SECRET_KEY_BASE: ${SECRET_KEY_BASE:0:10}... (hidden)"

# Pull latest image
echo ""
echo "🔄 Checking for updates..."
docker pull $DOCKER_IMAGE

# Stop old containers (but keep volumes if .env existed)
echo "🛑 Stopping old version..."
docker-compose -f $COMPOSE_FILE down 2>/dev/null || true

# Start new version with current environment variables
echo "🚀 Starting latest version..."
docker-compose -f $COMPOSE_FILE up -d

# Wait for database to be ready
echo "⏳ Waiting for database to be ready..."
RETRY_COUNT=0
MAX_RETRIES=30

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if docker-compose -f $COMPOSE_FILE exec -T db pg_isready -U student > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Database is ready!${NC}"
        break
    fi
    echo -n "."
    sleep 1
    RETRY_COUNT=$((RETRY_COUNT + 1))
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    echo -e "${RED}❌ Database failed to start${NC}"
    echo "Check logs: docker-compose -f $COMPOSE_FILE logs db"
    exit 1
fi

# Additional wait for PostgreSQL to fully initialize
sleep 5

# Check if web container is running
if ! docker ps | grep -q student_records_web; then
    echo -e "${RED}❌ ERROR: Web container failed to start${NC}"
    echo "📋 Check logs with: docker-compose -f $COMPOSE_FILE logs web"
    exit 1
fi

# Run migrations with error handling
echo ""
echo "🗄️  Setting up database..."

# Try to create database
if docker-compose -f $COMPOSE_FILE exec -T web bin/rails db:create 2>&1 | tee /tmp/db_create.log; then
    echo "✅ Database created"
else
    if grep -q "already exists" /tmp/db_create.log; then
        echo "ℹ️  Database already exists (this is normal)"
    elif grep -q "password authentication failed" /tmp/db_create.log; then
        echo -e "${RED}❌ PASSWORD MISMATCH DETECTED!${NC}"
        echo -e "${YELLOW}This means containers are using old password.${NC}"
        echo -e "${YELLOW}Recreating with correct credentials...${NC}"

        # Stop and remove everything including volumes
        docker-compose -f $COMPOSE_FILE down -v

        # Restart with current .env
        docker-compose -f $COMPOSE_FILE up -d

        # Wait for database again
        sleep 10

        # Try create again
        docker-compose -f $COMPOSE_FILE exec -T web bin/rails db:create 2>&1
    else
        echo -e "${YELLOW}⚠️  Warning during db:create (continuing...)${NC}"
    fi
fi

# Run migrations
echo "🔄 Running migrations..."
if docker-compose -f $COMPOSE_FILE exec -T web bin/rails db:migrate 2>&1; then
    echo -e "${GREEN}✅ Migrations completed${NC}"
else
    echo -e "${RED}❌ Migration failed${NC}"
    echo "Check logs: docker-compose -f $COMPOSE_FILE logs web"
    exit 1
fi

# Get IP
if [[ "$OSTYPE" == "darwin"* ]]; then
    LOCAL_IP=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}' | head -n 1)
else
    LOCAL_IP=$(hostname -I | awk '{print $1}')
fi

echo ""
echo "=========================================="
echo -e "${GREEN}✅ Deployment completed successfully!${NC}"
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
echo "  Reset DB:      docker-compose -f $COMPOSE_FILE down -v && ./deploy.sh"
echo ""
