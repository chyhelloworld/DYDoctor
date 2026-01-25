# DYDoctor Docker 快速启动指南

适用范围：项目拷贝到**其他电脑**后，30 分钟内通过 Docker 启动前后端，并完成数据库初始化与数据导入。

---

## 1. 前置条件

1. 已安装 Docker Desktop（Windows）或 Docker Engine（Linux）。
2. Docker 服务已启动。
3. 至少 4GB 可用内存。

---

## 2. 项目目录与关键路径

项目根目录记为 `<PROJECT_ROOT>`，例如：
- Windows：`E:\github\DYDoctor`
- Linux：`/opt/DYDoctor`

关键文件：
- `docker-compose.yml`：统一启动前端、后端、OpenGauss、Redis。
- `ruoyi-vue-pro-master-jdk17/sql/opengauss/`：数据库初始化脚本。
  - `00-create-user.sql`（创建用户）
  - `ruoyi-vue-pro.sql`（主业务表与基础数据）
  - `quartz.sql`（定时任务表）
  - `ai-opengauss.sql`（AI 相关表与数据）
- `yudao-ui-admin-vue3-master/.env.prod`：前端生产环境 API 配置。

---

## 3. 一键启动（推荐）

```bash
cd <PROJECT_ROOT>
docker compose up -d
```

> 首次启动会自动拉取镜像并执行数据库初始化脚本（需要 1-3 分钟）。

---

## 4. 数据库初始化与数据导入

默认情况下，OpenGauss 在首次启动时会自动执行挂载的 SQL 脚本：
- `00-create-user.sql`
- `ruoyi-vue-pro.sql`
- `quartz.sql`
- `ai-opengauss.sql`

如果确认数据库已初始化，可跳过本节。

### 4.1 验证是否已初始化

```bash
docker exec yudao-opengauss sh -c "cd /usr/local/opengauss && LD_LIBRARY_PATH=/usr/local/opengauss/lib:$LD_LIBRARY_PATH bin/gsql -U omm -W Yudao@2024 -d postgres -c '\dt'"
```

看到大量业务表则说明初始化成功。

### 4.2 手动重新导入（需要时）

> 仅当首次初始化失败或需要手动补数据时使用。

```bash
docker exec yudao-opengauss sh -c "cd /usr/local/opengauss && LD_LIBRARY_PATH=/usr/local/opengauss/lib:$LD_LIBRARY_PATH bin/gsql -U omm -W Yudao@2024 -d postgres -f /docker-entrypoint-initdb.d/01-schema.sql"
docker exec yudao-opengauss sh -c "cd /usr/local/opengauss && LD_LIBRARY_PATH=/usr/local/opengauss/lib:$LD_LIBRARY_PATH bin/gsql -U omm -W Yudao@2024 -d postgres -f /docker-entrypoint-initdb.d/02-quartz.sql"
docker exec yudao-opengauss sh -c "cd /usr/local/opengauss && LD_LIBRARY_PATH=/usr/local/opengauss/lib:$LD_LIBRARY_PATH bin/gsql -U omm -W Yudao@2024 -d postgres -f /docker-entrypoint-initdb.d/03-ai.sql"
```

> 说明：以上文件名与 `docker-compose.yml` 中的挂载一致：
> - `01-schema.sql` → `ruoyi-vue-pro.sql`
> - `02-quartz.sql` → `quartz.sql`
> - `03-ai.sql` → `ai-opengauss.sql`

---

## 5. 前后端启动与访问

### 5.1 后端（Spring Boot）
- 地址：`http://localhost:48080`

### 5.2 前端（Vue3 + Nginx）
- 地址：`http://localhost:18080`

浏览器访问：`http://localhost:18080`

---

## 6. 前端 API 地址配置

前端生产环境 API 地址来自 `yudao-ui-admin-vue3-master/.env.prod`：

```env
VITE_BASE_URL='http://localhost:48080'
VITE_API_URL=/admin-api
```

如果后端端口/域名变化，请修改 `VITE_BASE_URL` 后重新构建前端镜像：

```bash
docker compose build yudao-ui-admin-vue3
docker compose up -d --no-build yudao-ui-admin-vue3
```

---

## 7. 修改代码后如何编译并更新镜像

> 说明：Dockerfile 已包含编译步骤，不需要本地安装 Maven/Node。

### 7.1 仅修改后端

```bash
docker compose build yudao-server
docker compose up -d --no-build yudao-server
```

### 7.2 仅修改前端

```bash
docker compose build yudao-ui-admin-vue3
docker compose up -d --no-build yudao-ui-admin-vue3
```

### 7.3 同时修改前后端

```bash
docker compose build yudao-server yudao-ui-admin-vue3
docker compose up -d --no-build yudao-server yudao-ui-admin-vue3
```

---

## 8. 默认账号密码

**后台管理默认账号：**
- 用户名：`admin`
- 密码：`123456`

---

## 9. 常用 Docker 命令

```bash
# 拉取镜像
docker compose pull

# 构建镜像
docker compose build

# 启动服务
docker compose up -d

# 查看容器状态
docker compose ps

# 查看日志
docker compose logs yudao-server
docker compose logs yudao-ui-admin-vue3
docker compose logs opengauss
docker compose logs redis

# 进入容器
docker compose exec yudao-server sh
docker compose exec yudao-ui-admin-vue3 sh
docker compose exec opengauss sh

# 停止服务
docker compose stop

# 启动已停止的服务
docker compose start

# 重启服务
docker compose restart

# 删除容器
docker compose down

# 删除容器并清理数据卷（慎用）
docker compose down -v
```

---

## 10. 重置并重新初始化数据库

如需清空全部数据并重新导入：

```bash
cd <PROJECT_ROOT>
docker compose down -v
docker compose up -d
```

> 这会删除 OpenGauss 与 Redis 数据卷，请谨慎操作。

---

## 11. 常见问题排查（较完整）

### 11.1 数据库初始化未执行
1. 确认数据卷是全新：  
   ```bash
   docker volume ls
   docker volume inspect dydoctor-system_opengauss-data
   ```
2. 检查 SQL 是否挂载成功：  
   ```bash
   docker exec yudao-opengauss ls -la /docker-entrypoint-initdb.d/
   ```
3. 手动导入 SQL（见第 4.2 节）。

### 11.2 无法连接数据库
1. 确认容器正常运行：  
   ```bash
   docker compose ps
   ```
2. 查看数据库日志：  
   ```bash
   docker logs yudao-opengauss --tail 100
   ```
3. 使用 gsql 测试连接：  
   ```bash
   docker exec yudao-opengauss sh -c "cd /usr/local/opengauss && LD_LIBRARY_PATH=/usr/local/opengauss/lib:$LD_LIBRARY_PATH bin/gsql -U yudao -W Yudao@2024 -d postgres -c 'SELECT 1'"
   ```
4. 如果启动报端口占用，检查本机端口 5432 是否被占用并释放。

### 11.3 前端打不开或白屏
1. 确认前端容器运行：  
   ```bash
   docker compose ps
   ```
2. 查看前端日志：  
   ```bash
   docker compose logs yudao-ui-admin-vue3
   ```
3. 检查 `.env.prod` 的 `VITE_BASE_URL` 是否指向正确后端。

### 11.4 后端无法启动
1. 查看后端日志：  
   ```bash
   docker compose logs yudao-server
   ```
2. 检查数据库是否健康：  
   ```bash
   docker compose ps
   ```

---

## 12. 重要说明

1. 应用数据库用户：`yudao / Yudao@2024`（如有调整，以实际可登录为准）。
2. 数据库初始化脚本只在**首次创建数据卷**时自动执行。
3. 生产环境请修改默认密码，避免安全风险。
4. 更详细的开发指南: https://doc.iocoder.cn/quick-start/#_5-1-%E7%BC%96%E8%AF%91%E9%A1%B9%E7%9B%AE
