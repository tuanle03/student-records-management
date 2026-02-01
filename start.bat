@echo off
REM Student Records Management - Startup Script for Windows
REM This script starts the application with Docker Compose and opens it to LAN

echo.
echo ========================================
echo Student Records Management - Starting...
echo ========================================
echo.

REM Check if Docker is running
docker info >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker is not running. Please start Docker Desktop first.
    pause
    exit /b 1
)

REM Get local IP address
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4 Address"') do (
    set LOCAL_IP=%%a
    goto :ip_found
)
:ip_found
set LOCAL_IP=%LOCAL_IP:~1%

echo [INFO] Local IP Address: %LOCAL_IP%
echo.

REM Stop any existing containers
echo [INFO] Stopping existing containers...
docker-compose down 2>nul

REM Build and start services
echo [INFO] Building and starting services...
docker-compose up -d --build

if errorlevel 1 (
    echo [ERROR] Failed to start services.
    pause
    exit /b 1
)

REM Wait for database to be ready
echo [INFO] Waiting for database to be ready...
timeout /t 10 /nobreak >nul

REM Run database migrations
echo [INFO] Running database migrations...
docker-compose exec -T web bin/rails db:create db:migrate 2>nul

echo.
echo ========================================
echo [SUCCESS] Application is running!
echo ========================================
echo.
echo Local access:    http://localhost:8000
echo LAN access:      http://%LOCAL_IP%:8000
echo.
echo ========================================
echo.
echo Useful commands:
echo   - View logs:        docker-compose logs -f
echo   - Stop app:         docker-compose down
echo   - Restart:          docker-compose restart
echo   - Shell access:     docker-compose exec web bash
echo.
echo Press Ctrl+C to stop viewing logs (app keeps running)
echo.

REM Follow logs
docker-compose logs -f
