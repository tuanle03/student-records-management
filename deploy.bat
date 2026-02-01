@echo off
setlocal enabledelayedexpansion

set APP_NAME=Student Records Management
set DOCKER_IMAGE=tuanle03/student-records-management:latest
set COMPOSE_FILE=docker-compose.production.yml
set ENV_FILE=.env

echo.
echo ==========================================
echo %APP_NAME% - Auto Deploy
echo ==========================================
echo.

REM Check Docker
docker info >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker not running
    pause
    exit /b 1
)

REM Download docker-compose if needed
if not exist %COMPOSE_FILE% (
    echo [INFO] Downloading configuration...
    curl -sL https://raw.githubusercontent.com/tuanle03/student-records-management/main/docker-compose.production.yml -o %COMPOSE_FILE%
)

REM Check existing setup
set ENV_EXISTS=0
set CONTAINERS_RUNNING=0

if exist %ENV_FILE% (
    set ENV_EXISTS=1
    echo [INFO] Found existing .env file
)

docker ps | findstr student_records_db >nul 2>&1
if not errorlevel 1 (
    set CONTAINERS_RUNNING=1
    echo [WARNING] Containers are already running
)

REM Generate or load credentials
if not exist %ENV_FILE% (
    echo [INFO] Generating new credentials...

    REM Generate keys
    for /f "delims=" %%i in ('powershell -Command "[guid]::NewGuid().ToString() + [guid]::NewGuid().ToString() -replace '-',''"') do set SECRET_KEY_BASE=%%i
    for /f "delims=" %%i in ('powershell -Command "[Convert]::ToBase64String((1..32 | ForEach-Object {Get-Random -Maximum 256})) -replace '[^a-zA-Z0-9]',''"') do set DB_PASSWORD=%%i

    (
        echo # Auto-generated - DO NOT SHARE
        echo DB_PASSWORD=!DB_PASSWORD!
        echo SECRET_KEY_BASE=!SECRET_KEY_BASE!
        echo RAILS_MASTER_KEY=
    ) > %ENV_FILE%

    echo [SUCCESS] Credentials generated

    REM If containers running, need to reset
    if !CONTAINERS_RUNNING!==1 (
        echo [WARNING] New credentials but old containers running
        echo [INFO] Recreating containers with new credentials...
        docker-compose -f %COMPOSE_FILE% down -v 2>nul
        echo [SUCCESS] Old containers removed
    )
) else (
    echo [INFO] Using existing credentials
)

REM Load environment variables
echo [INFO] Loading environment...
for /f "usebackq tokens=1,* delims==" %%a in ("%ENV_FILE%") do (
    set "line=%%a"
    if not "!line:~0,1!"=="#" (
        set "%%a=%%b"
    )
)

REM Verify
if "%SECRET_KEY_BASE%"=="" (
    echo [ERROR] SECRET_KEY_BASE not set
    pause
    exit /b 1
)

if "%DB_PASSWORD%"=="" (
    echo [ERROR] DB_PASSWORD not set
    pause
    exit /b 1
)

echo [SUCCESS] Environment loaded
echo   DB_PASSWORD: %DB_PASSWORD:~0,5%... (hidden)
echo   SECRET_KEY_BASE: %SECRET_KEY_BASE:~0,10%... (hidden)

REM Pull latest
echo.
echo [INFO] Pulling latest version...
docker pull %DOCKER_IMAGE%

REM Stop old (keep volumes)
echo [INFO] Stopping old version...
docker-compose -f %COMPOSE_FILE% down 2>nul

REM Start new
echo [INFO] Starting services...
docker-compose -f %COMPOSE_FILE% up -d

if errorlevel 1 (
    echo [ERROR] Failed to start
    pause
    exit /b 1
)

REM Wait for database
echo [INFO] Waiting for database to be ready...
set RETRY=0
:wait_db
docker-compose -f %COMPOSE_FILE% exec -T db pg_isready -U student >nul 2>&1
if not errorlevel 1 goto db_ready
set /a RETRY+=1
if %RETRY% geq 30 (
    echo [ERROR] Database failed to start
    echo Check logs: docker-compose -f %COMPOSE_FILE% logs db
    pause
    exit /b 1
)
timeout /t 1 /nobreak >nul
goto wait_db

:db_ready
echo [SUCCESS] Database is ready

REM Additional wait
timeout /t 5 /nobreak >nul

REM Migrations
echo.
echo [INFO] Setting up database...

docker-compose -f %COMPOSE_FILE% exec -T web bin/rails db:create 2>nul
if errorlevel 1 (
    echo [WARNING] Database create had issues - checking...
    REM Try to detect password mismatch
    docker-compose -f %COMPOSE_FILE% logs web | findstr "password authentication failed" >nul
    if not errorlevel 1 (
        echo [ERROR] PASSWORD MISMATCH DETECTED!
        echo [INFO] Recreating with correct credentials...
        docker-compose -f %COMPOSE_FILE% down -v
        docker-compose -f %COMPOSE_FILE% up -d
        timeout /t 10 /nobreak >nul
        docker-compose -f %COMPOSE_FILE% exec -T web bin/rails db:create
    )
)

echo [INFO] Running migrations...
docker-compose -f %COMPOSE_FILE% exec -T web bin/rails db:migrate

if errorlevel 1 (
    echo [ERROR] Migration failed
    echo Check logs: docker-compose -f %COMPOSE_FILE% logs web
    pause
    exit /b 1
)

echo [SUCCESS] Migrations completed

REM Get IP
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4 Address"') do (
    set LOCAL_IP=%%a
    goto :ip_found
)
:ip_found
set LOCAL_IP=%LOCAL_IP:~1%

echo.
echo ==========================================
echo [SUCCESS] Deployment completed!
echo ==========================================
echo.
echo Access at:
echo   Local:  http://localhost:8000
echo   LAN:    http://%LOCAL_IP%:8000
echo.
echo ==========================================
echo.
echo Useful commands:
echo   View logs:  docker-compose -f %COMPOSE_FILE% logs -f
echo   Stop:       docker-compose -f %COMPOSE_FILE% down
echo   Reset DB:   docker-compose -f %COMPOSE_FILE% down -v
echo.
pause
