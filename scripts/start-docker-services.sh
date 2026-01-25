#!/bin/bash
# DYDoctor Docker Services Startup Script (Linux/macOS)
# For OpenGauss Database and Redis

set -e

echo "======================================"
echo "DYDoctor Docker Services Startup"
echo "======================================"
echo

# Check if Docker is running
echo "[1/7] Checking Docker status..."
if ! docker version &> /dev/null; then
    echo "Error: Docker is not running"
    echo "Please start Docker first"
    exit 1
fi
echo "Docker is running"
echo

# Change to project directory
cd "$(dirname "$0")/.."

# Check Docker images
echo "[2/7] Checking Docker images..."
echo "Pulling opengauss/opengauss:latest..."
docker pull opengauss/opengauss:latest
echo "Pulling redis:8.4-alpine..."
docker pull redis:8.4-alpine
echo "Images ready"
echo

# Stop and remove old containers
echo "[3/7] Cleaning old containers..."
docker compose down 2>/dev/null || true
echo "Cleanup done"
echo

# Start services
echo "[4/7] Starting OpenGauss and Redis services..."
docker compose up -d
echo "Services started successfully"
echo

# Wait for database to be ready
echo "[5/7] Waiting for OpenGauss to initialize (this may take 60-90 seconds)..."
echo

# Wait loop - check every 10 seconds
count=0
while [ $count -lt 9 ]; do
    count=$((count + 1))
    echo "  Checking... ($count/9)"
    sleep 10

    # Check if database is accepting connections
    if docker exec yudao-opengauss sh -c "cd /usr/local/opengauss && LD_LIBRARY_PATH=/usr/local/opengauss/lib:$LD_LIBRARY_PATH bin/gsql -U omm -W Yudao@2024 -d postgres -c 'SELECT 1'" &> /dev/null; then
        echo "  Database is ready!"
        break
    fi
done

echo
# Execute database initialization scripts
echo "[6/7] Executing database initialization scripts..."
echo
echo "注意：官方镜像不支持自动执行，需要手动执行初始化脚本"
echo

echo "  Executing main database script (ruoyi-vue-pro.sql)..."
echo "  This may take several minutes, please wait..."
docker exec yudao-opengauss sh -c "cd /usr/local/opengauss && LD_LIBRARY_PATH=/usr/local/opengauss/lib:$LD_LIBRARY_PATH bin/gsql -U omm -W Yudao@2024 -d postgres -f /docker-entrypoint-initdb.d/01-schema.sql"

echo "  Executing Quartz script (quartz.sql)..."
docker exec yudao-opengauss sh -c "cd /usr/local/opengauss && LD_LIBRARY_PATH=/usr/local/opengauss/lib:$LD_LIBRARY_PATH bin/gsql -U omm -W Yudao@2024 -d postgres -f /docker-entrypoint-initdb.d/02-quartz.sql" || echo "  Warning: Quartz script may have failed (may already exist)"

echo
# Configure remote access
echo "[7/7] Configuring remote access for Navicat..."
echo

# Create remote user
echo "  Creating remote user 'yudao'..."
docker exec yudao-opengauss sh -c "cd /usr/local/opengauss && LD_LIBRARY_PATH=/usr/local/opengauss/lib:$LD_LIBRARY_PATH bin/gsql -U omm -W Yudao@2024 -d postgres -c \"DROP USER IF EXISTS yudao; CREATE USER yudao WITH PASSWORD 'Yudao1234'; GRANT ALL PRIVILEGES TO yudao; ALTER USER yudao CREATEDB;\""

echo
echo "  Updating authentication configuration..."
docker exec yudao-opengauss sh -c "cat > /var/lib/opengauss/data/pg_hba.conf << 'EOFEOF'
# TYPE  DATABASE        USER            ADDRESS                 METHOD
local   all             all                                     trust
host    all             all             127.0.0.1/32            md5
host    all             all             ::1/128                 md5
host    all             all             0.0.0.0/0               md5
host    replication     all             0.0.0.0/0               md5
EOFEOF"

echo "  Restarting database to apply configuration..."
docker restart yudao-opengauss &> /dev/null

echo "  Waiting for restart to complete..."
sleep 20

echo
echo "======================================"
echo "Service Status:"
echo "======================================"
docker ps --filter "name=yudao" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo

echo "======================================"
echo "Navicat Connection Info:"
echo "======================================"
echo "  Host:      127.0.0.1"
echo "  Port:      5432"
echo "  Database:  postgres"
echo "  Username:  yudao"
echo "  Password:  Yudao1234"
echo "  SSL:       disable"
echo
echo "======================================"
echo "Internal Connection Info:"
echo "======================================"
echo "  Host:      127.0.0.1"
echo "  Port:      5432"
echo "  Database:  postgres"
echo "  Username:  omm"
echo "  Password:  Yudao@2024"
echo "  JDBC URL:  jdbc:postgresql://127.0.0.1:5432/postgres"
echo
echo "======================================"
echo "Redis Connection Info:"
echo "======================================"
echo "  Host: 127.0.0.1"
echo "  Port: 6379"
echo
