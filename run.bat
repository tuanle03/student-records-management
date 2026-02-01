@echo off
setlocal enabledelayedexpansion

set "APP_NAME=Student Records Management"
set "DOCKER_IMAGE=tuanle03/student-records-management:latest"
set "CONTAINER_NAME=srm_app"
set "DB_CONTAINER=srm_postgres"
set "NETWORK_NAME=srm_network"
set "ENV_FILE=srm.env"

echo.
echo ==========================================
echo %APP_NAME% - Quick Start
echo ==========================================
echo.

REM Check Docker
docker info >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker chua chay. Vui long khoi dong Docker Desktop!
    echo Download: https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)

REM Generate credentials if not exists
if not exist "%ENV_FILE%" (
    echo [INFO] Tao credentials lan dau...

    for /f "delims=" %%i in ('powershell -Command "[guid]::NewGuid().ToString() + [guid]::NewGuid().ToString() -replace '-',''"') do set "SECRET_KEY=%%i"
    for /f "delims=" %%i in ('powershell -Command "$bytes = New-Object byte[] 32; [System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($bytes); [Convert]::ToBase64String($bytes) -replace '[^a-zA-Z0-9]',''"') do set "DB_PASS=%%i"

    (
        echo # Student Records Management - Environment Config
        echo # Generated: %date% %time%
        echo.
        echo DB_PASSWORD=!DB_PASS!
        echo SECRET_KEY_BASE=!SECRET_KEY!
    ) > "%ENV_FILE%"

    echo [SUCCESS] Da tao file %ENV_FILE%
    echo [WARNING] Luu y: Khong chia se file nay!
)

REM Load environment variables
echo [INFO] Dang load cau hinh...
for /f "usebackq tokens=1,* delims==" %%a in ("%ENV_FILE%") do (
    set "line=%%a"
    if not "!line:~0,1!"=="#" (
        if not "%%a"=="" set "%%a=%%b"
    )
)

REM Create network
docker network inspect %NETWORK_NAME% >nul 2>&1
if errorlevel 1 (
    echo [INFO] Tao Docker network...
    docker network create %NETWORK_NAME%
)

REM Check if database exists
docker ps -a | findstr %DB_CONTAINER% >nul 2>&1
if errorlevel 1 (
    echo [INFO] Khoi tao database container...
    docker run -d ^
        --name %DB_CONTAINER% ^
        --network %NETWORK_NAME% ^
        -e POSTGRES_DB=student_records_management_production ^
        -e POSTGRES_USER=student ^
        -e POSTGRES_PASSWORD=%DB_PASSWORD% ^
        -v srm_postgres_data:/var/lib/postgresql/data ^
        --restart unless-stopped ^
        postgres:15

    echo [INFO] Cho database khoi dong...
    timeout /t 10 /nobreak >nul
) else (
    docker start %DB_CONTAINER% >nul 2>&1
    echo [INFO] Database container da san sang
)

REM Pull latest image
echo [INFO] Dang tai phien ban moi nhat...
docker pull %DOCKER_IMAGE%

REM Stop old app container if running
docker stop %CONTAINER_NAME% >nul 2>&1
docker rm %CONTAINER_NAME% >nul 2>&1

REM Run app container
echo [INFO] Khoi dong ung dung...
docker run -d ^
    --name %CONTAINER_NAME% ^
    --network %NETWORK_NAME% ^
    -e RAILS_ENV=production ^
    -e DB_HOST=%DB_CONTAINER% ^
    -e DB_PORT=5432 ^
    -e DB_NAME=student_records_management_production ^
    -e DB_USER=student ^
    -e DB_PASSWORD=%DB_PASSWORD% ^
    -e SECRET_KEY_BASE=%SECRET_KEY_BASE% ^
    -e RAILS_LOG_TO_STDOUT=true ^
    -p 0.0.0.0:8000:80 ^
    --restart unless-stopped ^
    %DOCKER_IMAGE%

if errorlevel 1 (
    echo [ERROR] Khoi dong that bai!
    pause
    exit /b 1
)

REM Wait for app to be ready
echo [INFO] Cho ung dung khoi dong...
timeout /t 15 /nobreak >nul

REM Run migrations
echo [INFO] Chay database migrations...
docker exec %CONTAINER_NAME% bin/rails db:create db:migrate 2>nul

REM Get local IP
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4 Address"') do (
    set "LOCAL_IP=%%a"
    goto :ip_found
)
:ip_found
set "LOCAL_IP=%LOCAL_IP:~1%"

echo.
echo ==========================================
echo [SUCCESS] Ung dung da chay thanh cong!
echo ==========================================
echo.
echo Truy cap tai:
echo   - Local:  http://localhost:8000
echo   - LAN:    http://%LOCAL_IP%:8000
echo.
echo Lenh quan ly:
echo   - Xem logs:     docker logs -f %CONTAINER_NAME%
echo   - Dung lai:     docker stop %CONTAINER_NAME% %DB_CONTAINER%
echo   - Khoi dong:    docker start %DB_CONTAINER% %CONTAINER_NAME%
echo   - Xoa du lieu:  docker rm -f %CONTAINER_NAME% %DB_CONTAINER% ^&^& docker volume rm srm_postgres_data
echo.
pause
