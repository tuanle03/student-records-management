@echo off
REM Student Records Management - One-Click Deployment
REM Auto-generates secrets for security

setlocal enabledelayedexpansion

set APP_NAME=Student Records Management
set DOCKER_IMAGE=tuanle03/student-records-management:latest
set COMPOSE_FILE=docker-compose.production.yml
set ENV_FILE=.env

echo.
echo ==========================================
echo %APP_NAME% - Auto Update and Deploy
echo ==========================================
echo.

REM Check Docker
docker info >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker is not running.
    echo Please install/start Docker Desktop first.
    echo Download: https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)

REM Download config if not exists
if not exist %COMPOSE_FILE% (
    echo [INFO] Downloading configuration file...
    curl -sL https://raw.githubusercontent.com/tuanle03/student-records-management/main/docker-compose.production.yml -o %COMPOSE_FILE%
)

REM Create .env file if not exists
if not exist %ENV_FILE% (
    echo [INFO] Generating secure credentials...

    REM Generate random keys using PowerShell
    for /f "delims=" %%i in ('powershell -Command "[guid]::NewGuid().ToString() + [guid]::NewGuid().ToString() -replace '-',''"') do set SECRET_KEY_BASE=%%i
    for /f "delims=" %%i in ('powershell -Command "[Convert]::ToBase64String((1..32 | ForEach-Object {Get-Random -Maximum 256})) -replace '[^a-zA-Z0-9]',''"') do set DB_PASSWORD=%%i

    (
        echo # Auto-generated configuration - DO NOT SHARE THIS FILE
        echo # Generated on: %date% %time%
        echo.
        echo # Database Configuration
        echo DB_PASSWORD=!DB_PASSWORD!
        echo.
        echo # Rails Secret Key ^(DO NOT CHANGE after first deployment^)
        echo SECRET_KEY_BASE=!SECRET_KEY_BASE!
        echo.
        echo # Optional: Uncomment to use custom master key
        echo # RAILS_MASTER_KEY=your_key_here
        echo.
        echo # Optional: Custom port
        echo # APP_PORT=8000
    ) > %ENV_FILE%

    echo [SUCCESS] Credentials generated and saved to .env
    echo [WARNING] IMPORTANT: Keep .env file secure - do not share it!
) else (
    echo [INFO] Using existing credentials from .env
)

REM Pull latest image
echo [INFO] Checking for updates...
docker pull %DOCKER_IMAGE%

REM Stop old version
echo [INFO] Stopping old version...
docker-compose -f %COMPOSE_FILE% down 2>nul

REM Start new version
echo [INFO] Starting latest version...
docker-compose -f %COMPOSE_FILE% up -d

if errorlevel 1 (
    echo [ERROR] Failed to start services.
    pause
    exit /b 1
)

REM Wait for services
echo [INFO] Waiting for services to start...
timeout /t 15 /nobreak >nul

REM Run migrations
echo [INFO] Setting up database...
docker-compose -f %COMPOSE_FILE% exec -T web bin/rails db:create 2>nul
docker-compose -f %COMPOSE_FILE% exec -T web bin/rails db:migrate 2>nul

REM Get IP
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4 Address"') do (
    set LOCAL_IP=%%a
    goto :ip_found
)
:ip_found
set LOCAL_IP=%LOCAL_IP:~1%

echo.
echo ==========================================
echo [SUCCESS] Deployment completed successfully!
echo ==========================================
echo.
echo Access the application at:
echo    Local:  http://localhost:8000
echo    LAN:    http://%LOCAL_IP%:8000
echo.
echo ==========================================
echo.
echo Useful commands:
echo   View logs:     docker-compose -f %COMPOSE_FILE% logs -f
echo   Stop app:      docker-compose -f %COMPOSE_FILE% down
echo   Restart:       docker-compose -f %COMPOSE_FILE% restart
echo.
pause
