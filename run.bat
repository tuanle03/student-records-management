@echo off
setlocal enabledelayedexpansion

:: Script tu dong khoi dong ung dung Quan Ly Thong Tin Hoc Vien voi host tuy chinh qlhv.local
:: Nguoi dung chi can chay file nay, tat ca se duoc thuc hien tu dong.

:: Cau hinh ung dung
set "TEN_UNG_DUNG=Quan Ly Thong Tin Hoc Vien"
set "HINH_ANH_DOCKER=tuanle03/student-records-management:latest"
set "TEN_CONTAINER_UNG_DUNG=qlhv_ung_dung"
set "TEN_CONTAINER_DB=qlhv_postgres"
set "TEN_MANG=qlhv_mang"
set "FILE_ENV=.env"
set "FILE_ENV_PHU=qlhv.env"
set "HOST_TUY_CHINH=qlhv.local"
set "PORT_UNG_DUNG=8000"
set "HOSTS_FILE=C:\Windows\System32\drivers\etc\hosts"

echo.
echo ==========================================
echo %TEN_UNG_DUNG% - Khoi Dong Nhanh
echo ==========================================
echo.

:: Buoc 1: Kiem tra quyen Administrator
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [THONG BAO] Dang chay voi quyen Administrator.
) else (
    echo [LOI] Vui long chay script nay voi quyen Administrator de chinh sua file hosts!
    echo Nhan chuot phai vao run.bat ^> "Run as administrator".
    pause
    exit /b 1
)

:: Buoc 2: Kiem tra Docker
docker info >nul 2>&1
if errorlevel 1 (
    echo [LOI] Docker chua chay. Vui long khoi dong Docker Desktop!
    echo Tai tai: https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)
echo [THANH CONG] Docker da san sang!

:: Buoc 3: Tu dong them host tuy chinh vao file hosts
findstr /c:"%HOST_TUY_CHINH%" "%HOSTS_FILE%" >nul 2>&1
if errorlevel 1 (
    echo 127.0.0.1 %HOST_TUY_CHINH% >> "%HOSTS_FILE%"
    echo [THANH CONG] Da them '%HOST_TUY_CHINH%' vao file hosts!
) else (
    echo [CANH BAO] Host '%HOST_TUY_CHINH%' da ton tai trong file hosts.
)

:: Buoc 4: Tai bien moi truong
set "LOADED_ENV_FILE="
if exist "%FILE_ENV%" (
    echo [THONG BAO] Dang tai cau hinh tu %FILE_ENV%...
    set "LOADED_ENV_FILE=%FILE_ENV%"
    goto :load_env
) else if exist "%FILE_ENV_PHU%" (
    echo [THONG BAO] Dang tai cau hinh tu %FILE_ENV_PHU%...
    set "LOADED_ENV_FILE=%FILE_ENV_PHU%"
    goto :load_env
) else (
    echo [THONG BAO] Khong tim thay file .env, dang tao %FILE_ENV_PHU% lan dau...
    goto :generate_env
)

:generate_env
for /f "delims=" %%i in ('powershell -Command "[guid]::NewGuid().ToString() + [guid]::NewGuid().ToString() -replace '-',''"') do set "SECRET_KEY_BASE=%%i"
for /f "delims=" %%i in ('powershell -Command "$bytes = New-Object byte[] 32; [System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($bytes); [Convert]::ToBase64String($bytes) -replace '[^a-zA-Z0-9]',''"') do set "DB_PASSWORD=%%i"

(
    echo # Quan Ly Ho So Sinh Vien - Cau Hinh Moi Truong
    echo # Tao ngay: %date% %time%
    echo.
    echo DB_PASSWORD=!DB_PASSWORD!
    echo SECRET_KEY_BASE=!SECRET_KEY_BASE!
) > "%FILE_ENV_PHU%"

echo [THANH CONG] Da tao file %FILE_ENV_PHU%
echo [CANH BAO] Luu y: Khong chia se file nay!
echo [MEO] Ban co the tao file .env de su dung mat khau tuy chinh
set "LOADED_ENV_FILE=%FILE_ENV_PHU%"
goto :load_env

:load_env
for /f "usebackq tokens=1,* delims==" %%a in ("!LOADED_ENV_FILE!") do (
    set "line=%%a"
    if not "!line:~0,1!"=="#" (
        if not "%%a"=="" set "%%a=%%b"
    )
)

:: Buoc 5: Xac minh bien can thiet
if "!DB_PASSWORD!"=="" (
    echo [LOI] Thieu DB_PASSWORD trong file env
    pause
    exit /b 1
)
if "!SECRET_KEY_BASE!"=="" (
    echo [LOI] Thieu SECRET_KEY_BASE trong file env
    pause
    exit /b 1
)
echo [THANH CONG] Cau hinh moi truong da san sang!

:: Buoc 6: Tao mang Docker
docker network inspect %TEN_MANG% >nul 2>&1
if errorlevel 1 (
    echo [THONG BAO] Dang tao mang Docker...
    docker network create %TEN_MANG%
    echo [THANH CONG] Da tao mang '%TEN_MANG%'!
)

:: Buoc 7: Khoi tao container database
docker ps -a --format "table {{.Names}}" | findstr /c:"%TEN_CONTAINER_DB%" >nul 2>&1
if errorlevel 1 (
    echo [THONG BAO] Dang khoi tao container database...
    docker run -d ^
        --name %TEN_CONTAINER_DB% ^
        --network %TEN_MANG% ^
        -e POSTGRES_DB=student_records_management_production ^
        -e POSTGRES_USER=student ^
        -e POSTGRES_PASSWORD="!DB_PASSWORD!" ^
        -v qlhv_postgres_data:/var/lib/postgresql/data ^
        --restart unless-stopped ^
        postgres:15

    echo [THONG BAO] Dang cho database khoi dong...
    timeout /t 10 /nobreak >nul
    echo [THANH CONG] Database da san sang!
) else (
    docker start %TEN_CONTAINER_DB% >nul 2>&1
    echo [THANH CONG] Container database da ton tai va dang chay!
)

:: Buoc 8: Tai hinh anh Docker moi nhat
echo [THONG BAO] Dang tai phien ban ung dung moi nhat...
docker pull %HINH_ANH_DOCKER%
echo [THANH CONG] Da tai xong!

:: Buoc 9: Dung va xoa container ung dung cu
docker stop %TEN_CONTAINER_UNG_DUNG% >nul 2>&1
docker rm %TEN_CONTAINER_UNG_DUNG% >nul 2>&1

:: Buoc 10: Khoi dong container ung dung
echo [THONG BAO] Dang khoi dong ung dung tren host '%HOST_TUY_CHINH%'...
docker run -d ^
    --name %TEN_CONTAINER_UNG_DUNG% ^
    --network %TEN_MANG% ^
    -e RAILS_ENV=production ^
    -e DB_HOST=%TEN_CONTAINER_DB% ^
    -e DB_PORT=5432 ^
    -e DB_NAME=student_records_management_production ^
    -e DB_USER=student ^
    -e DB_PASSWORD="!DB_PASSWORD!" ^
    -e SECRET_KEY_BASE="!SECRET_KEY_BASE!" ^
    -e RAILS_LOG_TO_STDOUT=true ^
    -p 127.0.0.1:%PORT_UNG_DUNG%:80 ^
    --restart unless-stopped ^
    %HINH_ANH_DOCKER%

:: Buoc 11: Cho ung dung khoi dong
echo [THONG BAO] Dang cho ung dung khoi dong...
timeout /t 15 /nobreak >nul

:: Buoc 12: Chay migration database
echo [THONG BAO] Dang chay migration database...
docker exec %TEN_CONTAINER_UNG_DUNG% bin/rails db:create db:migrate >nul 2>&1
echo [THANH CONG] Migration hoan thanh!

:: Buoc 13: Hien thi thong tin truy cap
echo.
echo ==========================================
echo [THANH CONG] Ung dung da chay thanh cong tren host tuy chinh!
echo ==========================================
echo.
echo 🌐 Truy cap tai:
echo    - Host tuy chinh: http://%HOST_TUY_CHINH%:%PORT_UNG_DUNG%
echo    - Local:          http://localhost:%PORT_UNG_DUNG%
echo.
echo 📋 Len h quan ly:
echo    - Xem logs:       docker logs -f %TEN_CONTAINER_UNG_DUNG%
echo    - Dung lai:       docker stop %TEN_CONTAINER_UNG_DUNG% %TEN_CONTAINER_DB%
echo    - Khoi dong lai:  docker start %TEN_CONTAINER_DB% %TEN_CONTAINER_UNG_DUNG%
echo    - Xoa du lieu:    docker rm -f %TEN_CONTAINER_UNG_DUNG% %TEN_CONTAINER_DB% ^& docker volume rm qlhv_postgres_data
echo.
echo 🎉 Hoan thanh! Chi can mo trinh duyet va truy cap http://%HOST_TUY_CHINH%:%PORT_UNG_DUNG%

pause
