# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

DYDoctor 是一个基于芋道快速开发平台构建的医疗行业管理系统，采用前后端分离架构。

- **后端项目**: `ruoyi-vue-pro-master-jdk17/` - 基于 Spring Boot 3.5.9 + JDK 17
- **前端项目**: `yudao-ui-admin-vue3-master/` - 基于 Vue 3 + Element Plus + Vite

### 技术栈

**后端核心框架**:
- Spring Boot 3.5.9 (应用框架)
- Spring Security 6.5.2 (安全框架)
- MyBatis Plus 3.5.12 (ORM)
- Redis + Redisson (缓存)
- MySQL 8.0+ (数据库)
- Flowable 7.0.0 (工作流引擎)

**前端核心框架**:
- Vue 3.5.12
- Element Plus 2.11.1
- TypeScript 5.3.3
- Vite 5.1.4
- Pinia 2.1.7 (状态管理)
- Vue Router 4.4.5

## 常用命令

### 后端开发

```bash
# 进入后端项目目录
cd ruoyi-vue-pro-master-jdk17

# 编译项目
mvn clean compile

# 运行单元测试
mvn test

# 打包项目
mvn clean package

# 跳过测试打包
mvn clean package -DskipTests

#综合打包命令
mvn clean install package '-Dmaven.test.skip=true'

# 启动应用（开发环境）
java -jar yudao-server/target/yudao-server.jar

# 指定配置文件启动
java -jar yudao-server/target/yudao-server.jar --spring.profiles.active=local
```

### 前端开发

```bash
# 进入前端项目目录
cd yudao-ui-admin-vue3-master

# 安装依赖（必须使用 pnpm）
pnpm install

# 本地开发启动
pnpm dev

# 类型检查
pnpm ts:check

# 构建本地环境
pnpm build:local

# 构建开发环境
pnpm build:dev

# 构建测试环境
pnpm build:test

# 构建生产环境
pnpm build:prod

# 代码检查和修复
pnpm lint:eslint
pnpm lint:format
pnpm lint:style
```

### 数据库初始化

```bash
# 导入主数据库
mysql -u root -p ruoyi-vue-pro < ruoyi-vue-pro-master-jdk17/sql/mysql/ruoyi-vue-pro.sql

# 导入 Quartz 定时任务表
mysql -u root -p ruoyi-vue-pro < ruoyi-vue-pro-master-jdk17/sql/mysql/quartz.sql
```

## 项目架构

### 后端模块架构

项目采用多模块 Maven 架构，核心模块如下：

```
ruoyi-vue-pro-master-jdk17/
├── yudao-dependencies/          # Maven 依赖版本统一管理
├── yudao-framework/             # 框架封装（各种 Starter）
│   ├── yudao-common/            # 通用工具类
│   ├── yudao-spring-boot-starter-security/    # 安全认证
│   ├── yudao-spring-boot-starter-web/         # Web 配置
│   ├── yudao-spring-boot-starter-mybatis/     # MyBatis 扩展
│   ├── yudao-spring-boot-starter-redis/       # Redis 封装
│   ├── yudao-spring-boot-starter-job/         # 定时任务
│   └── ...
├── yudao-server/                # 主启动模块（引入需要的模块依赖）
├── yudao-module-system/         # 系统功能模块（用户、角色、菜单等）
├── yudao-module-infra/          # 基础设施模块（代码生成、文件管理等）
└── (其他业务模块，按需启用)
    ├── yudao-module-bpm/        # 工作流程
    ├── yudao-module-pay/        # 支付系统
    ├── yudao-module-mall/       # 商城系统
    └── ...
```

### 后端代码分层

每个业务模块采用标准的三层架构：

```
cn.iocoder.yudao.module.{module}/
├── controller/              # 控制层（API 接口）
│   └── admin/              # 管理后台的 Controller
├── service/                # 服务层
│   ├── {业务}Service.java  # Service 接口
│   └── impl/               # Service 实现
├── dal/                    # 数据访问层
│   ├── dataobject/         # 数据对象（DO，对应数据库表）
│   └── mysql/              # MyBatis Mapper
├── convert/                # 对象转换（MapStruct）
└── api/                    # 模块间 API 调用接口
```

**关键约定**:
- Controller: 处理 HTTP 请求，使用 `@RestController` 和 `@RequestMapping`
- Service: 业务逻辑层，接口定义在 `service/`，实现在 `service/impl/`
- DO (DataObject): 数据库实体，继承 `TenantBaseDO`（支持多租户）
- Mapper: MyBatis Plus Mapper，使用 `@Mapper` 注解
- VO (View Object): 前端交互对象，放在 `controller/admin/xx/vo/` 下

### 前端项目结构

```
yudao-ui-admin-vue3-master/
├── src/
│   ├── api/                 # API 接口定义（按模块分类）
│   ├── assets/              # 静态资源
│   ├── components/          # 全局组件
│   ├── config/              # 配置文件
│   ├── directives/          # 自定义指令
│   ├── hooks/               # Vue 组合式 API hooks
│   ├── layout/              # 布局组件
│   ├── locales/             # 国际化文件
│   ├── router/              # 路由配置
│   ├── store/               # Pinia 状态管理
│   ├── styles/              # 全局样式
│   ├── types/               # TypeScript 类型定义
│   ├── utils/               # 工具函数
│   └── views/               # 页面组件（按模块分类）
│       ├── ai/             # AI 相关页面
│       ├── bpm/            # 工作流页面
│       ├── system/         # 系统管理页面
│       ├── infra/          # 基础设施页面
│       └── ...
├── .env.local               # 本地开发环境配置
├── .env.dev                 # 开发环境配置
├── .env.test                # 测试环境配置
├── .env.prod                # 生产环境配置
└── vite.config.ts           # Vite 配置
```

### 环境配置说明

**后端配置文件**:
- `application.yaml` - 主配置文件
- `application-local.yaml` - 本地开发环境
- `application-dev.yaml` - 开发环境
- `application-test.yaml` - 测试环境

**前端环境变量**:
- `VITE_BASE_URL` - 后端 API 地址
- `VITE_API_URL` - API 路径前缀（默认 `/admin-api`）
- `VITE_PORT` - 开发服务器端口

本地开发默认配置：
- 后端: `http://localhost:48080`
- 前端: 端口由 `.env.local` 中的 `VITE_PORT` 指定

## 重要架构概念

### 多租户支持

- 后端通过 `TenantBaseDO` 基类自动实现多租户隔离
- 大部分表都包含 `tenant_id` 字段
- 前端通过请求头自动携带租户信息

### 权限控制

- 基于 Spring Security + JWT 实现
- 支持基于角色的权限控制（RBAC）
- 按钮级别权限通过 `@PreAuthorize` 注解控制

### 代码生成

项目内置代码生成器，位于 `yudao-module-infra` 模块：
- 可生成前后端完整代码
- 支持单表、树表、主子表
- 访问路径: 基础设施 → 代码生成

### 工作流引擎

- 使用 Flowable 7.0.0
- 支持 BPMN 2.0 标准
- 提供可视化流程设计器
- 位于 `yudao-module-bpm` 模块

## 开发注意事项

### 后端开发

1. **添加新功能时**，遵循现有模块结构创建对应的 Controller、Service、Mapper
2. **DO 类必须继承 `TenantBaseDO`** 以支持多租户
3. **使用 MapStruct** 进行对象转换，避免手动映射
4. **API 接口统一返回** `CommonResult<T>` 包装类型
5. **数据库表命名规范**: `system_` 前缀（系统模块）、`infra_` 前缀（基础设施）

### 前端开发

1. **API 接口统一在 `src/api/` 下定义**
2. **使用 Composition API** 编写组件
3. **状态管理使用 Pinia**
4. **路由配置在 `src/router/` 下管理**
5. **遵守 ESLint 和 Prettier 规范**

### 模块启用/禁用

在 `yudao-server/pom.xml` 中控制模块的启用：

```xml
<!-- 取消注释即可启用对应模块 -->
<!-- <dependency> -->
<!--     <groupId>cn.iocoder.boot</groupId> -->
<!--     <artifactId>yudao-module-bpm</artifactId> -->
<!-- </dependency> -->
```

常用模块：
- `yudao-module-system` - 系统功能（必选）
- `yudao-module-infra` - 基础设施（必选）
- `yudao-module-bpm` - 工作流（可选）
- `yudao-module-pay` - 支付（可选）
- `yudao-module-mall` - 商城（可选）

## 相关文档

- 芋道官方文档: https://doc.iocoder.cn
- 视频教程: https://doc.iocoder.cn/video/
- Spring Boot 文档: https://spring.io/projects/spring-boot
- Vue 3 文档: https://cn.vuejs.org
- Element Plus 文档: https://element-plus.org/zh-CN
