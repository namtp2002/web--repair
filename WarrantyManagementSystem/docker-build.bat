@echo off
REM ===========================================
REM Script để build và deploy Docker trên Windows
REM ===========================================

echo =====================================
echo Warranty Management System - Docker Build
echo =====================================

REM Bước 1: Clean và Build Maven project
echo.
echo Step 1: Building Maven project...
call mvn clean package -DskipTests

if errorlevel 1 (
    echo ERROR: Maven build failed!
    exit /b 1
)

REM Bước 2: Stop và remove containers cũ (nếu có)
echo.
echo Step 2: Stopping old containers...
docker-compose down

REM Bước 3: Build Docker images
echo.
echo Step 3: Building Docker images...
docker-compose build --no-cache

if errorlevel 1 (
    echo ERROR: Docker build failed!
    exit /b 1
)

REM Bước 4: Start containers
echo.
echo Step 4: Starting containers...
docker-compose up -d

if errorlevel 1 (
    echo ERROR: Failed to start containers!
    exit /b 1
)

REM Bước 5: Wait for services to be ready
echo.
echo Step 5: Waiting for services to be ready...
echo Waiting for MySQL...
timeout /t 10 /nobreak > nul

echo Waiting for Tomcat...
timeout /t 15 /nobreak > nul

REM Bước 6: Check status
echo.
echo Step 6: Checking container status...
docker-compose ps

REM Bước 7: Show information
echo.
echo =====================================
echo Deployment completed!
echo =====================================
echo.
echo Application URL: http://localhost:8080
echo.
echo MySQL Connection:
echo   Host: localhost
echo   Port: 3306
echo   Database: warranty_system
echo   Username: warranty_user
echo   Password: warranty_pass
echo.
echo To view logs:
echo   docker-compose logs -f web
echo   docker-compose logs -f mysql
echo.
echo To stop:
echo   docker-compose down
echo.
echo To restart:
echo   docker-compose restart
echo.

pause
