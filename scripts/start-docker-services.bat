@echo off
REM DYDoctor Docker Service Startup Script
REM For OpenGauss Database and Redis

setlocal enabledelayedexpansion

echo ======================================
echo DYDoctor Docker Services Startup
echo ======================================
echo.

REM Check if Docker is running
echo [1/7] Checking Docker status...
docker version >nul 2>&1
if errorlevel 1 (
    echo Error: Docker is not running
    echo Please start Docker Desktop first
    pause
    exit /b 1
)
echo Docker is running
echo.

REM Detect Docker Compose command format
echo Detecting Docker Compose command format...
docker compose version >nul 2>&1
if errorlevel 1 (
    echo Using docker-compose (v1)
    set COMPOSE_CMD=docker-compose
) else (
    echo Using docker compose (v2)
    set COMPOSE_CMD=docker compose
)
echo.

REM Change to project directory
cd /d e:\github\DYDoctor

REM Check Docker images
echo [2/7] Checking Docker images...
echo Pulling opengauss/opengauss:latest...
docker pull opengauss/opengauss:latest
echo Pulling redis:8.4-alpine...
docker pull redis:8.4-alpine
echo Images ready
echo.

REM Stop and remove old containers
echo [3/7] Cleaning old containers...
%COMPOSE_CMD% down 2>nul
echo Cleanup done
echo.

REM Start services
echo [4/7] Starting OpenGauss and Redis services...
%COMPOSE_CMD% up -d
if errorlevel 1 (
    echo Error: Failed to start services
    pause
    exit /b 1
)
echo Services started successfully
echo.

REM Wait for database to be ready
echo [5/7] Waiting for OpenGauss to initialize (this may take 60-90 seconds)...
echo.

REM Wait loop - check every 10 seconds
set /a count=0
:waitloop
set /a count=%count%+1
echo   Checking... (%count%/9)
timeout /t 10 /nobreak >nul

REM Check if database is accepting connections
docker exec yudao-opengauss sh -c "cd /usr/local/opengauss && LD_LIBRARY_PATH=/usr/local/opengauss/lib:$LD_LIBRARY_PATH bin/gsql -U omm -W Yudao@2024 -d postgres -c 'SELECT 1'" >nul 2>&1
if errorlevel 1 (
    if %count% lss 9 (
        goto waitloop
    ) else (
        echo   Warning: Database may not be fully ready, continuing...
    )
)

echo   Database is ready!
echo.

REM Execute database initialization scripts
echo [6/7] Executing database initialization scripts...
echo.
echo 注意：官方镜像不支持自动执行，需要手动执行初始化脚本
echo.

echo   Executing main database script (ruoyi-vue-pro.sql)...
echo   This may take several minutes, please wait...
docker exec yudao-opengauss sh -c "cd /usr/local/opengauss && LD_LIBRARY_PATH=/usr/local/opengauss/lib:$LD_LIBRARY_PATH bin/gsql -U omm -W Yudao@2024 -d postgres -f /docker-entrypoint-initdb.d/01-schema.sql"
if errorlevel 1 (
    echo   Error: Failed to execute main database script
    pause
    exit /b 1
)
echo   Main database script executed successfully
echo.

echo   Executing Quartz script (quartz.sql)...
docker exec yudao-opengauss sh -c "cd /usr/local/opengauss && LD_LIBRARY_PATH=/usr/local/opengauss/lib:$LD_LIBRARY_PATH bin/gsql -U omm -W Yudao@2024 -d postgres -f /docker-entrypoint-initdb.d/02-quartz.sql"
if errorlevel 1 (
    echo   Warning: Quartz script execution failed (may already exist)
) else (
    echo   Quartz script executed successfully
)
echo.

REM Configure remote access
echo [7/7] Configuring remote access for Navicat...
echo.

REM Create remote user
echo   Creating remote user 'yudao'...
docker exec yudao-opengauss sh -c "cd /usr/local/opengauss && LD_LIBRARY_PATH=/usr/local/opengauss/lib:$LD_LIBRARY_PATH bin/gsql -U omm -W Yudao@2024 -d postgres -c \"DROP USER IF EXISTS yudao; CREATE USER yudao WITH PASSWORD 'Yudao1234'; GRANT ALL PRIVILEGES TO yudao; ALTER USER yudao CREATEDB;\""

echo.
echo   Updating authentication configuration...
docker exec yudao-opengauss sh -c "cat > /var/lib/opengauss/data/pg_hba.conf << 'EOFEOF'
# TYPE  DATABASE        USER            ADDRESS                 METHOD
local   all             all                                     trust
host    all             all             127.0.0.1/32            md5
host    all             all             ::1/128                 md5
host    all             all             0.0.0.0/0               md5
host    replication     all             0.0.0.0/0               md5
EOFEOF"

echo   Restarting database to apply configuration...
docker restart yudao-opengauss >nul 2>&1

echo   Waiting for restart to complete...
timeout /t 20 /nobreak >nul

echo.
echo ======================================
echo Service Status:
echo ======================================
docker ps --filter "name=yudao" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo.

echo ======================================
echo Navicat Connection Info:
echo ======================================
echo   Host:      127.0.0.1
echo   Port:      5432
echo   Database:  postgres
echo   Username:  yudao
echo   Password:  Yudao1234
echo   SSL:       disable
echo.
echo ======================================
echo Internal Connection Info:
echo ======================================
echo   Host:      127.0.0.1
echo   Port:      5432
echo   Database:  postgres
echo   Username:  omm
echo   Password:  Yudao@2024
echo   JDBC URL:  jdbc:postgresql://127.0.0.1:5432/postgres
echo.
echo ======================================
echo Redis Connection Info:
echo ======================================
echo   Host: 127.0.0.1
echo   Port: 6379
echo.
pause
