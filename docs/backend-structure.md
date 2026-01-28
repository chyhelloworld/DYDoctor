# DYDoctor 后端项目目录结构详细分析

> 本文档详细说明了 DYDoctor 后端项目的目录结构、各模块功能及代码组织方式

## 一、项目顶层结构

```
ruoyi-vue-pro-master-jdk17/
├── pom.xml                              # Maven 主配置文件，定义项目结构、模块依赖、构建插件
├── .gitignore                          # Git 版本控制忽略规则配置
├── LICENSE                             # 项目许可证文件
├── README.md                           # 项目说明文档
├── lombok.config                       # Lombok 注解处理器配置
├── .flattened-pom.xml                  # Maven 扁平化 POM（自动生成）
├── script/                             # 脚本文件目录（启动、部署等）
├── sql/                                # 数据库初始化脚本目录
│   ├── mysql/                          # MySQL 数据库脚本
│   │   ├── ruoyi-vue-pro.sql          # 主数据库结构
│   │   ├── ai-mysql.sql                # AI 模块表结构
│   │   ├── member-*.sql               # 会员模块表结构
│   │   └── quartz.sql                 # Quartz 定时任务表
│   ├── oracle/                         # Oracle 数据库脚本
│   ├── postgresql/                     # PostgreSQL 数据库脚本
│   └── ...                             # 其他数据库支持
│
├── yudao-dependencies/                  # 【依赖管理模块】
│   └── pom.xml                         # 统一管理所有第三方依赖版本
│
├── yudao-framework/                     # 【框架封装模块】各种 Spring Boot Starter
│   ├── yudao-common/                   # 通用工具类和基础类
│   ├── yudao-spring-boot-starter-security/    # 安全认证封装
│   ├── yudao-spring-boot-starter-web/         # Web 配置封装
│   ├── yudao-spring-boot-starter-mybatis/     # MyBatis Plus 扩展
│   ├── yudao-spring-boot-starter-redis/       # Redis 缓存封装
│   ├── yudao-spring-boot-starter-biz-tenant/  # 多租户支持
│   ├── yudao-spring-boot-starter-biz-data-permission/  # 数据权限
│   └── ...                             # 其他框架封装
│
├── yudao-server/                       # 【主启动模块】应用入口
│   ├── src/main/java/                  # Java 源码
│   │   └── cn/iocoder/yudao/server/
│   │       ├── YudaoServerApplication.java  # Spring Boot 启动类
│   │       └── controller/             # 全局控制器（较少使用）
│   ├── src/main/resources/             # 配置文件
│   │   ├── application.yaml           # 主配置文件
│   │   ├── application-local.yaml     # 本地环境配置
│   │   ├── application-dev.yaml       # 开发环境配置
│   │   ├── application-test.yaml      # 测试环境配置
│   │   ├── application-prod.yaml      # 生产环境配置
│   │   └── logback-spring.xml         # 日志配置
│   ├── Dockerfile                      # Docker 镜像构建文件
│   └── pom.xml                         # 模块依赖配置（引入需要的业务模块）
│
└── yudao-module-*/                     # 【业务模块集合】
    ├── yudao-module-system/           # 系统功能模块（必选）
    ├── yudao-module-infra/            # 基础设施模块（必选）
    ├── yudao-module-ai/               # AI 大模型模块
    ├── yudao-module-member/           # 会员中心模块（可选）
    ├── yudao-module-bpm/              # 工作流模块（可选）
    ├── yudao-module-pay/              # 支付模块（可选）
    ├── yudao-module-mall/             # 商城模块（可选）
    └── ...                             # 其他业务模块
```

---

## 二、yudao-dependencies 模块

**作用**: Maven 依赖版本统一管理，避免版本冲突

```
yudao-dependencies/
└── pom.xml                              # 定义所有依赖的版本号
    ├── spring.boot.version: 3.5.9
    ├── java.version: 17
    ├── mapstruct.version: 1.6.3
    ├── lombok.version: 1.18.42
    └── ...                             # 其他依赖版本
```

---

## 三、yudao-framework 框架模块

每个 starter 都是独立的可重用组件：

### 3.1 yudao-common（通用工具模块）

```
yudao-common/
└── src/main/java/cn/iocoder/yudao/framework/common/
    ├── pojo/                           # 通用数据对象
    │   ├── CommonResult.java           # 统一响应结果封装
    │   ├── PageParam.java              # 分页查询参数
    │   ├── PageResult.java             # 分页结果封装
    │   └── SortablePageParam.java      # 可排序分页参数
    │
    ├── exception/                      # 异常处理
    │   ├── ErrorCode.java              # 错误码接口
    │   ├── ServiceException.java       # 业务异常
    │   ├── ServerException.java        # 服务器异常
    │   └── enums/
    │       └── GlobalErrorCodeConstants.java  # 全局错误码常量
    │
    ├── util/                           # 工具类集合
    │   ├── collection/                 # 集合工具类
    │   │   ├── CollectionUtils.java
    │   │   ├── ArrayUtils.java
    │   │   └── MapUtils.java
    │   ├── date/                       # 日期工具
    │   │   ├── DateUtils.java
    │   │   └── LocalDateTimeUtils.java
    │   ├── json/                       # JSON 工具
    │   │   └── JsonUtils.java
    │   ├── object/                     # 对象工具
    │   │   ├── BeanUtils.java          # Bean 转换
    │   │   └── ObjectUtils.java
    │   ├── string/                     # 字符串工具
    │   │   └── StrUtils.java
    │   ├── validation/                 # 验证工具
    │   │   └── ValidationUtils.java
    │   └── ...                         # 其他工具类
    │
    ├── validation/                      # 自定义验证注解
    │   ├── Mobile.java                 # 手机号验证
    │   ├── Telephone.java              # 电话号验证
    │   └── InEnum.java                 # 枚举值验证
    │
    ├── enums/                          # 通用枚举
    │   ├── CommonStatusEnum.java       # 通用状态枚举
    │   ├── UserTypeEnum.java           # 用户类型枚举
    │   └── TerminalEnum.java           # 终端类型枚举
    │
    └── biz/                            # 跨模块 API 定义
        ├── system/                     # 系统模块 API
        │   ├── dict/
        │   ├── permission/
        │   ├── oauth2/
        │   └── ...
        └── infra/                      # 基础设施 API
            └── logger/
```

### 3.2 yudao-spring-boot-starter-security（安全认证模块）

```
yudao-spring-boot-starter-security/
└── src/main/java/
    ├── config/                         # 安全配置
    │   └── YudaoSecurityAutoConfiguration.java
    ├── core/                           # 核心组件
    │   ├── filter/                     # 过滤器
    │   │   ├── TokenAuthenticationFilter.java  # Token 认证过滤器
    │   │   └── TenantContextWebFilter.java     # 租户上下文过滤器
    │   ├── handler/                    # 处理器
    │   │   ├── SecurityAuthenticationEntryPoint.java  # 未认证处理
    │   │   └── SecurityAccessDeniedHandler.java         # 无权限处理
    │   └── service/                    # 安全服务
    │       ├── TokenService.java       # Token 服务
    │       └── UserDetailsServiceImpl.java  # 用户详情服务
    └── ...
```

### 3.3 yudao-spring-boot-starter-mybatis（数据库模块）

```
yudao-spring-boot-starter-mybatis/
└── src/main/java/
    ├── config/                         # MyBatis 配置
    │   └── YudaoMybatisAutoConfiguration.java
    ├── core/                           # 核心
    │   ├── base/                       # 基础 Mapper
    │   │   └── BaseMapperX.java        # 通用 Mapper
    │   ├── enums/                      # 枚举
    │   │   └── DbHistoryExistException.java
    │   └── service/                    # 服务
    │       └── BaseService.java       # 基础 Service
    └── ...
```

### 3.4 yudao-spring-boot-starter-biz-tenant（多租户模块）

```
yudao-spring-boot-starter-biz-tenant/
└── src/main/java/
    ├── config/
    │   ├── YudaoTenantAutoConfiguration.java
    │   └── TenantProperties.java       # 租户配置属性
    ├── core/
    │   ├── aop/                        # AOP 切面
    │   │   ├── TenantIgnore.java       # 忽略租户注解
    │   │   └── TenantIgnoreAspect.java
    │   ├── context/                    # 上下文
    │   │   └── TenantContextHolder.java  # 租户上下文持有者
    │   ├── db/                         # 数据库
    │   │   ├── TenantBaseDO.java       # 租户基类（DO 必须继承）
    │   │   └── TenantDatabaseInterceptor.java  # MyBatis 租户拦截器
    │   └── rpc/                        # RPC
    │       └── TenantRequestInterceptor.java
    └── ...
```

### 3.5 yudao-spring-boot-starter-biz-data-permission（数据权限模块）

```
yudao-spring-boot-starter-biz-data-permission/
└── src/main/java/
    ├── core/
    │   ├── annotation/
    │   │   └── DataPermission.java     # 数据权限注解
    │   ├── aop/                        # AOP
    │   │   └── DataPermissionAnnotationInterceptor.java
    │   ├── rule/                       # 规则
    │   │   ├── DataPermissionRule.java
    │   │   └── dept/
    │   │       └── DeptDataPermissionRule.java  # 部门数据权限规则
    │   └── db/
    │       └── DataPermissionRuleHandler.java
    └── ...
```

### 3.6 其他框架模块

| 模块名 | 作用 |
|--------|------|
| yudao-spring-boot-starter-web | Web 配置、CORS、全局异常处理 |
| yudao-spring-boot-starter-redis | Redis 缓存、分布式锁 |
| yudao-spring-boot-starter-job | 定时任务（XXL-Job） |
| yudao-spring-boot-starter-mq | 消息队列（RocketMQ/Kafka/RabbitMQ） |
| yudao-spring-boot-starter-excel | Excel 导入导出 |
| yudao-spring-boot-starter-protection | 服务保障（限流、熔断） |
| yudao-spring-boot-starter-websocket | WebSocket 支持 |
| yudao-spring-boot-starter-biz-ip | IP 地址解析、区域处理 |

---

## 四、yudao-server 主启动模块

```
yudao-server/
├── src/main/java/cn/iocoder/yudao/server/
│   ├── YudaoServerApplication.java     # Spring Boot 启动类
│   │   ├── @SpringBootApplication      # 启用自动配置
│   │   └── main() 方法                # 应用入口
│   │
│   └── controller/                     # 全局控制器（一般不在此写业务代码）
│       └── (预留，用于全局接口)
│
├── src/main/resources/
│   ├── application.yaml                # 主配置文件（所有环境共用）
│   ├── application-local.yaml          # 本地开发环境配置
│   ├── application-dev.yaml            # 开发环境配置
│   ├── application-test.yaml           # 测试环境配置
│   ├── application-prod.yaml           # 生产环境配置
│   └── logback-spring.xml              # 日志配置
│
├── Dockerfile                          # Docker 镜像构建文件
└── pom.xml                             # 模块依赖配置
    ├── 引入 yudao-module-system       # 系统功能
    ├── 引入 yudao-module-infra        # 基础设施
    ├── 引入 yudao-module-ai           # AI 功能（已启用）
    └── (其他可选模块)
```

### application.yaml 主要配置项

```yaml
spring:
  application:
    name: yudao-server                   # 应用名称
  profiles:
    active: local                        # 当前激活环境
  datasource:                            # 数据源配置
  redis:                                 # Redis 配置

mybatis-plus:                            # MyBatis Plus 配置
  configuration:
    map-underscore-to-camel-case: true
  global-config:
    db-config:
      logic-delete-value: 1              # 逻辑删除值

yudao:                                   # 芋道自定义配置
  info:
    base-package: cn.iocoder.yudao       # 基础包名
  security:                              # 安全配置
  tenant:                                # 多租户配置
  web:                                   # Web 配置
  swagger:                               # 接口文档配置
```

---

## 五、业务模块标准结构

每个业务模块都遵循统一的目录结构：

```
yudao-module-system/
├── pom.xml                              # 模块依赖配置
├── src/main/java/cn/iocoder/yudao/module/system/
│   │
│   ├── controller/                      # 【控制层】API 接口
│   │   ├── admin/                      # 管理后台接口
│   │   │   ├── auth/
│   │   │   │   ├── AuthController.java         # 认证接口
│   │   │   │   └── vo/                          # 视图对象
│   │   │   │       ├── AuthLoginReqVO.java     # 登录请求
│   │   │   │       ├── AuthLoginRespVO.java    # 登录响应
│   │   │   │       └── ...
│   │   │   ├── user/
│   │   │   │   ├── UserController.java         # 用户管理接口
│   │   │   │   └── vo/
│   │   │   │       ├── UserSaveReqVO.java
│   │   │   │       ├── UserPageReqVO.java
│   │   │   │       └── UserRespVO.java
│   │   │   ├── dept/                    # 部门管理
│   │   │   ├── role/                    # 角色管理
│   │   │   ├── menu/                    # 菜单管理
│   │   │   ├── permission/              # 权限管理
│   │   │   ├── dict/                    # 数据字典
│   │   │   ├── oauth2/                  # OAuth2
│   │   │   ├── mail/                    # 邮件
│   │   │   ├── sms/                     # 短信
│   │   │   ├── notice/                  # 通知
│   │   │   ├── logger/                  # 日志
│   │   │   └── tenant/                  # 租户
│   │   └── app/                        # 移动端接口（如果有）
│   │
│   ├── service/                         # 【服务层】业务逻辑
│   │   ├── auth/
│   │   │   ├── AdminAuthService.java           # 认证服务接口
│   │   │   └── impl/
│   │   │       └── AdminAuthServiceImpl.java   # 认证服务实现
│   │   ├── user/
│   │   │   ├── UserService.java
│   │   │   └── impl/
│   │   │       └── UserServiceImpl.java
│   │   ├── (其他 service)
│   │   └── package-info.java
│   │
│   ├── dal/                             # 【数据访问层】
│   │   ├── dataobject/                 # 数据对象（DO，对应数据库表）
│   │   │   ├── user/
│   │   │   │   ├── UserDO.java                 # 用户 DO
│   │   │   │   └── package-info.java
│   │   │   ├── dept/
│   │   │   │   ├── DeptDO.java
│   │   │   │   └── ...
│   │   │   └── (其他 DO)
│   │   │
│   │   ├── mysql/                      # MyBatis Mapper
│   │   │   ├── UserMapper.java                 # 用户 Mapper（继承 BaseMapperX）
│   │   │   ├── DeptMapper.java
│   │   │   ├── RoleMapper.java
│   │   │   └── ...
│   │   │
│   │   └── redis/                      # Redis 操作（如果有）
│   │       └── (Redis 缓存操作)
│   │
│   ├── convert/                         # 【对象转换】MapStruct 转换器
│   │   ├── AuthConvert.java            # 认证相关对象转换
│   │   ├── UserConvert.java            # 用户相关对象转换
│   │   └── ...
│   │
│   ├── api/                             # 【模块间 API】供其他模块调用
│   │   ├── user/
│   │   │   ├── AdminUserApi.java               # 用户 API 接口
│   │   │   ├── AdminUserApiImpl.java           # 用户 API 实现
│   │   │   └── dto/
│   │   │       └── AdminUserRespDTO.java       # API 数据传输对象
│   │   ├── permission/
│   │   │   ├── PermissionApi.java
│   │   │   └── ...
│   │   ├── dept/
│   │   ├── dict/
│   │   ├── oauth2/
│   │   └── ...
│   │
│   ├── framework/                       # 【框架扩展】模块级配置
│   │   ├── rpc/                        # RPC 配置
│   │   ├── mq/                         # 消息队列配置
│   │   └── ...
│   │
│   ├── job/                             # 【定时任务】XXL-Job 任务
│   │   └── (定时任务实现)
│   │
│   ├── mq/                              # 【消息队列】生产者/消费者
│   │   ├── consumer/                   # 消息消费者
│   │   └── producer/                   # 消息生产者
│   │
│   ├── enums/                           # 【枚举定义】
│   │   ├── ErrorCodeConstants.java     # 错误码常量
│   │   └── ...
│   │
│   └── util/                            # 【工具类】模块专用工具
│       └── ...
│
└── src/main/resources/                  # 模块资源文件
    ├── mapper/                          # MyBatis XML 映射文件（如果有复杂查询）
    │   └── (xml 文件)
    └── (其他资源)
```

---

## 六、各层代码说明

### 6.1 Controller（控制层）

**职责**: 处理 HTTP 请求，参数校验，调用 Service，返回响应

```java
@RestController
@RequestMapping("/admin-api/system/user")
public class UserController {

    @GetMapping("/page")
    public CommonResult<PageResult<UserRespVO>> getUserPage(@Valid UserPageReqVO pageVO) {
        // 1. 参数校验（由 @Valid 自动完成）
        // 2. 调用 Service
        PageResult<UserDO> page = userService.getUserPage(pageVO);
        // 3. 对象转换
        PageResult<UserRespVO> result = UserConvert.INSTANCE.convertPage(page);
        // 4. 返回响应
        return success(result);
    }
}
```

### 6.2 Service（服务层）

**职责**: 业务逻辑处理

```java
public interface UserService {
    Long createUser(UserSaveReqVO createReqVO);
    void updateUser(UserSaveReqVO updateReqVO);
    void deleteUser(Long id);
    UserDO getUser(Long id);
    PageResult<UserDO> getUserPage(UserPageReqVO pageVO);
}

@Service
public class UserServiceImpl implements UserService {

    @Resource
    private UserMapper userMapper;

    @Override
    public Long createUser(UserSaveReqVO createReqVO) {
        // 1. 参数校验
        validateUserExists(null, createReqVO.getUsername());
        // 2. 插入数据库
        UserDO user = UserConvert.INSTANCE.convert(createReqVO);
        userMapper.insert(user);
        return user.getId();
    }
}
```

### 6.3 DAL（数据访问层）

#### DO（DataObject）- 数据对象

```java
@TableName("system_users")
public class UserDO extends TenantBaseDO {  // 继承租户基类
    @TableId(type = IdType.AUTO)
    private Long id;
    private String username;
    private String password;
    private String nickname;
    private String mobile;
    // ... 其他字段
}
```

#### Mapper - MyBatis Mapper

```java
@Mapper
public interface UserMapper extends BaseMapperX<UserDO> {

    default PageResult<UserDO> selectPage(UserPageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<UserDO>()
                .likeIfPresent(UserDO::getUsername, reqVO.getUsername())
                .likeIfPresent(UserDO::getMobile, reqVO.getMobile())
                .betweenIfPresent(UserDO::getCreateTime, reqVO.getCreateTime())
                .orderByDesc(UserDO::getId));
    }
}
```

### 6.4 Convert（对象转换）

```java
@Mapper
public interface UserConvert {
    UserConvert INSTANCE = Mappers.getMapper(UserConvert.class);

    UserDO convert(UserSaveReqVO bean);
    UserRespVO convert(UserDO bean);
    List<UserRespVO> convertList(List<UserDO> list);
    PageResult<UserRespVO> convertPage(PageResult<UserDO> page);
}
```

### 6.5 VO（View Object）- 视图对象

放在 `controller/admin/*/vo/` 下：

- `*ReqVO` - 请求参数对象
- `*RespVO` - 响应结果对象
- `*PageReqVO` - 分页查询参数
- `*SaveReqVO` - 新增/编辑参数

### 6.6 API（模块间调用）

```java
// API 接口定义
public interface AdminUserApi {
    AdminUserRespDTO getUser(Long id);
    List<AdminUserRespDTO> getUserList(Collection<Long> ids);
}

// API 实现（供本地调用）
@ServiceImpl
public class AdminUserApiImpl implements AdminUserApi {
    @Resource
    private UserService userService;

    @Override
    public AdminUserRespDTO getUser(Long id) {
        UserDO user = userService.getUser(id);
        return UserConvert.INSTANCE.convert2(user);
    }
}
```

---

## 七、模块启用控制

在 `yudao-server/pom.xml` 中控制模块启用：

```xml
<!-- 已启用模块 -->
<dependency>
    <groupId>cn.iocoder.boot</groupId>
    <artifactId>yudao-module-system</artifactId>
</dependency>
<dependency>
    <groupId>cn.iocoder.boot</groupId>
    <artifactId>yudao-module-infra</artifactId>
</dependency>
<dependency>
    <groupId>cn.iocoder.boot</groupId>
    <artifactId>yudao-module-ai</artifactId>
</dependency>

<!-- 可选模块（注释状态） -->
<!-- <dependency> -->
<!--     <groupId>cn.iocoder.boot</groupId>-->
<!--     <artifactId>yudao-module-bpm</artifactId>-->
<!-- </dependency> -->
```

---

## 八、关键设计模式

| 设计模式 | 应用场景 |
|---------|---------|
| 三层架构 | Controller → Service → Mapper |
| 依赖注入 | @Resource/@Autowired 自动装配 |
| AOP 切面 | 数据权限、多租户、事务管理 |
| 策略模式 | 多种登录方式、多种支付方式 |
| 工厂模式 | 数据权限规则工厂 |
| 适配器模式 | 多种短信渠道、邮件渠道 |
| 观察者模式 | 事件监听、消息队列 |

---

## 九、包命名约定

| 包名 | 说明 | 示例 |
|-----|------|-----|
| `*.controller.admin.*` | 管理后台接口 | `AuthController.java` |
| `*.controller.app.*` | 移动端接口 | - |
| `*.service.*` | 服务层接口 | `UserService.java` |
| `*.service.impl.*` | 服务层实现 | `UserServiceImpl.java` |
| `*.dal.dataobject.*` | 数据对象 | `UserDO.java` |
| `*.dal.mysql.*` | MyBatis Mapper | `UserMapper.java` |
| `*.controller.*.vo.*` | 视图对象 | `UserRespVO.java` |
| `*.api.*` | 模块间 API | `AdminUserApi.java` |
| `*.convert.*` | 对象转换 | `UserConvert.java` |

---

## 十、已启用的业务模块

### 10.1 yudao-module-system（系统模块）

提供系统基础功能：

| 功能 | 说明 |
|-----|------|
| 用户管理 | 用户 CRUD、密码管理、用户导入导出 |
| 角色管理 | 角色 CRUD、角色权限分配 |
| 菜单管理 | 菜单树、动态路由、按钮权限 |
| 部门管理 | 部门树结构、部门人员 |
| 岗位管理 | 岗位信息维护 |
| 字典管理 | 字典类型、字典数据 |
| 参数设置 | 系统参数配置 |
| 通知公告 | 系统公告发布 |
| 操作日志 | 用户操作审计 |
| 登录日志 | 登录记录追踪 |
| 短信管理 | 短信模板、短信发送 |
| 邮件管理 | 邮件账号、邮件模板 |
| OAuth2 | 第三方登录集成 |
| 社交登录 | 微信、QQ 等社交登录 |

### 10.2 yudao-module-infra（基础设施模块）

提供开发基础设施：

| 功能 | 说明 |
|-----|------|
| 代码生成 | 根据数据表生成前后端代码 |
| 文件管理 | 文件上传、存储、下载 |
| 定时任务 | Quartz 定时任务管理 |
| API 日志 | 接口访问日志、错误日志 |
| 数据源管理 | 多数据源配置 |

### 10.3 yudao-module-ai（AI 模块）

提供 AI 大模型集成：

| 功能 | 说明 |
|-----|------|
| 对话管理 | AI 对话会话、消息管理 |
| 知识库 | 文档上传、向量化、检索 |
| 图片生成 | Midjourney 图片生成 |
| 绘图创作 | Suno 音乐生成 |
| 模型管理 | 多种 AI 模型切换 |

---

## 十一、开发规范

### 11.1 添加新功能流程

1. 在对应模块的 `dal/dataobject/` 下创建 DO 类
2. 在 `dal/mysql/` 下创建 Mapper 接口
3. 在 `service/` 下创建 Service 接口
4. 在 `service/impl/` 下创建 Service 实现类
5. 在 `controller/admin/` 下创建 Controller
6. 在 `controller/admin/*/vo/` 下创建 VO 类
7. 在 `convert/` 下创建 Convert 转换器

### 11.2 代码规范

- **DO 必须继承 `TenantBaseDO`** 以支持多租户
- **Mapper 必须继承 `BaseMapperX<DO>`** 获得基础 CRUD 方法
- **Service 接口放在 `service/` 包下**
- **Service 实现放在 `service/impl/` 包下**
- **Controller 使用 `@RestController` 和 `@RequestMapping`**
- **API 统一返回 `CommonResult<T>` 类型**
- **使用 MapStruct 进行对象转换**

### 11.3 注解使用

| 注解 | 用途 |
|-----|------|
| `@RestController` | 标记 Controller |
| `@RequestMapping` | 定义请求路径 |
| `@GetMapping/@PostMapping` | 定义 HTTP 方法 |
| `@Valid` | 参数校验 |
| `@Resource/@Autowired` | 依赖注入 |
| `@Service` | 标记 Service |
| `@Mapper` | 标记 MyBatis Mapper |
| `@TableName` | 指定表名 |
| `@TableId` | 指定主键 |
| `@TableField` | 指定字段映射 |

---

## 十二、常用命令

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

# 综合打包命令
mvn clean install package '-Dmaven.test.skip=true'

# 启动应用（开发环境）
java -jar yudao-server/target/yudao-server.jar

# 指定配置文件启动
java -jar yudao-server/target/yudao-server.jar --spring.profiles.active=local
```

---

*本文档最后更新于 2026-01-28*
