# 如何新增后端模块指南

> 本文档详细说明如何在 DYDoctor 项目中新增一个符合项目规范的后端业务模块

## 目录

- [一、创建模块目录结构](#一创建模块目录结构)
- [二、配置模块 pom.xml](#二配置模块-pomxml)
- [三、创建标准目录结构](#三创建标准目录结构)
- [四、编写各层代码](#四编写各层代码)
- [五、注册模块到项目](#五注册模块到项目)
- [六、完整示例](#六完整示例)

---

## 一、创建模块目录结构

在 `ruoyi-vue-pro-master-jdk17/` 目录下创建新模块：

```bash
# 假设新模块名为 yudao-module-{业务名}
mkdir -p yudao-module-{业务名}/src/main/java/cn/iocoder/yudao/module/{业务名}/
mkdir -p yudao-module-{业务名}/src/main/resources/
mkdir -p yudao-module-{业务名}/src/test/java/
```

**目录命名规范**：
- 模块名称格式：`yudao-module-{业务名}`
- 业务名使用小写，如：`nvr`、`medical`、`patient`
- 包名对应：`cn.iocoder.yudao.module.{业务名}`

---

## 二、配置模块 pom.xml

### 2.1 创建模块 pom.xml

在 `yudao-module-{业务名}/pom.xml` 中添加：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <groupId>cn.iocoder.boot</groupId>
        <artifactId>yudao</artifactId>
        <version>${revision}</version>
    </parent>
    <modelVersion>4.0.0</modelVersion>
    <artifactId>yudao-module-{业务名}</artifactId>
    <packaging>jar</packaging>

    <name>${project.artifactId}</name>
    <description>
        {业务名} 模块，用于 {模块功能描述}
    </description>

    <dependencies>
        <!-- 依赖 infra 模块（包含代码生成、文件管理等基础功能） -->
        <dependency>
            <groupId>cn.iocoder.boot</groupId>
            <artifactId>yudao-module-infra</artifactId>
            <version>${revision}</version>
        </dependency>

        <!-- 业务组件 -->
        <dependency>
            <groupId>cn.iocoder.boot</groupId>
            <artifactId>yudao-spring-boot-starter-biz-data-permission</artifactId>
        </dependency>
        <dependency>
            <groupId>cn.iocoder.boot</groupId>
            <artifactId>yudao-spring-boot-starter-biz-tenant</artifactId>
        </dependency>

        <!-- Web 相关 -->
        <dependency>
            <groupId>cn.iocoder.boot</groupId>
            <artifactId>yudao-spring-boot-starter-security</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-validation</artifactId>
        </dependency>

        <!-- DB 相关 -->
        <dependency>
            <groupId>cn.iocoder.boot</groupId>
            <artifactId>yudao-spring-boot-starter-mybatis</artifactId>
        </dependency>
        <dependency>
            <groupId>cn.iocoder.boot</groupId>
            <artifactId>yudao-spring-boot-starter-redis</artifactId>
        </dependency>

        <!-- 定时任务（可选） -->
        <dependency>
            <groupId>cn.iocoder.boot</groupId>
            <artifactId>yudao-spring-boot-starter-job</artifactId>
        </dependency>

        <!-- 消息队列（可选） -->
        <dependency>
            <groupId>cn.iocoder.boot</groupId>
            <artifactId>yudao-spring-boot-starter-mq</artifactId>
        </dependency>

        <!-- 工具类相关 -->
        <dependency>
            <groupId>cn.iocoder.boot</groupId>
            <artifactId>yudao-spring-boot-starter-excel</artifactId>
        </dependency>

        <!-- 测试相关 -->
        <dependency>
            <groupId>cn.iocoder.boot</groupId>
            <artifactId>yudao-spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

</project>
```

---

## 三、创建标准目录结构

```
yudao-module-{业务名}/
├── pom.xml
└── src/main/java/cn/iocoder/yudao/module/{业务名}/
    ├── api/                           # 【模块间 API】
    │   └── {功能}/
    │       ├── {功能}Api.java         # API 接口
    │       ├── {功能}ApiImpl.java     # API 实现
    │       └── dto/                   # 数据传输对象
    │
    ├── controller/                    # 【控制层】
    │   └── admin/                     # 管理后台接口
    │       └── {功能}/
    │           ├── {功能}Controller.java
    │           └── vo/                # 视图对象
    │               ├── {功能}SaveReqVO.java      # 新增/编辑请求
    │               ├── {功能}PageReqVO.java      # 分页查询请求
    │               ├── {功能}RespVO.java         # 响应结果
    │               └── {功能}SimpleRespVO.java   # 简单响应（下拉选项）
    │
    ├── service/                       # 【服务层】
    │   └── {功能}/
    │       ├── {功能}Service.java     # 服务接口
    │       └── impl/
    │           └── {功能}ServiceImpl.java  # 服务实现
    │
    ├── dal/                           # 【数据访问层】
    │   ├── dataobject/                # 数据对象（DO）
    │   │   └── {功能}/
    │   │       ├── {功能}DO.java
    │   │       └── package-info.java
    │   └── mysql/                     # MyBatis Mapper
    │       └── {功能}/
    │           ├── {功能}Mapper.java
    │           └── package-info.java
    │
    ├── convert/                       # 【对象转换】
    │   └── {功能}Convert.java
    │
    ├── enums/                         # 【枚举类】
    │   └── {相关枚举}.java
    │
    └── framework/                     # 【框架扩展】（可选）
        └── rpc/                       # RPC 配置
            └── {相关配置}.java
```

---

## 四、编写各层代码

### 4.1 DO（数据对象）

**文件位置**: `dal/dataobject/{功能}/{功能}DO.java`

```java
package cn.iocoder.yudao.module.{业务名}.dal.dataobject.{功能};

import cn.iocoder.yudao.framework.tenant.core.db.TenantBaseDO;
import com.baomidou.mybatisplus.annotation.*;
import lombok.*;

/**
 * {功能描述} DO
 *
 * @author {作者名}
 */
@TableName("{表名}")
@KeySequence("{表名}_seq")  // Oracle/PostgreSQL 等数据库需要
@Data
@EqualsAndHashCode(callSuper = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class {功能}DO extends TenantBaseDO {

    /**
     * 主键ID
     */
    @TableId
    private Long id;

    /**
     * 名称
     */
    private String name;

    /**
     * 编码
     */
    private String code;

    /**
     * 状态
     *
     * 枚举 {@link {状态枚举类}}
     */
    private Integer status;

    /**
     * 备注
     */
    private String remark;

}
```

**关键点**：
- 必须继承 `TenantBaseDO` 以支持多租户
- 使用 `@TableName` 指定数据库表名
- 使用 `@KeySequence` 支持非 MySQL 数据库
- 使用 Lombok 注解简化代码

### 4.2 Mapper（数据访问接口）

**文件位置**: `dal/mysql/{功能}/{功能}Mapper.java`

```java
package cn.iocoder.yudao.module.{业务名}.dal.mysql.{功能};

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.yudao.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.yudao.module.{业务名}.controller.admin.{功能}.vo.{功能}PageReqVO;
import cn.iocoder.yudao.module.{业务名}.dal.dataobject.{功能}.{功能}DO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * {功能} Mapper
 *
 * @author {作者名}
 */
@Mapper
public interface {功能}Mapper extends BaseMapperX<{功能}DO> {

    /**
     * 分页查询
     */
    default PageResult<{功能}DO> selectPage({功能}PageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<{功能}DO>()
                .likeIfPresent({功能}DO::getName, reqVO.getName())
                .likeIfPresent({功能}DO::getCode, reqVO.getCode())
                .eqIfPresent({功能}DO::getStatus, reqVO.getStatus())
                .betweenIfPresent({功能}DO::getCreateTime, reqVO.getCreateTime())
                .orderByDesc({功能}DO::getId));
    }

    /**
     * 列表查询
     */
    default List<{功能}DO> selectList() {
        return selectList();
    }

}
```

**关键点**：
- 必须继承 `BaseMapperX<DO>` 获得基础 CRUD 方法
- 使用 `LambdaQueryWrapperX` 构建查询条件
- 使用 `*IfPresent` 方法避免空值查询

### 4.3 Service（服务层）

#### 服务接口

**文件位置**: `service/{功能}/{功能}Service.java`

```java
package cn.iocoder.yudao.module.{业务名}.service.{功能};

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.{业务名}.controller.admin.{功能}.vo.*;
import cn.iocoder.yudao.module.{业务名}.dal.dataobject.{功能}.{功能}DO;
import jakarta.validation.Valid;

import java.util.List;

/**
 * {功能} Service 接口
 *
 * @author {作者名}
 */
public interface {功能}Service {

    /**
     * 创建{功能}
     *
     * @param createReqVO 创建信息
     * @return 编号
     */
    Long create{功能}(@Valid {功能}SaveReqVO createReqVO);

    /**
     * 更新{功能}
     *
     * @param updateReqVO 更新信息
     */
    void update{功能}(@Valid {功能}SaveReqVO updateReqVO);

    /**
     * 删除{功能}
     *
     * @param id 编号
     */
    void delete{功能}(Long id);

    /**
     * 获得{功能}
     *
     * @param id 编号
     * @return {功能}信息
     */
    {功能}DO get{功能}(Long id);

    /**
     * 获得{功能}分页
     *
     * @param pageReqVO 分页查询
     * @return {功能}分页
     */
    PageResult<{功能}DO> get{功能}Page({功能}PageReqVO pageReqVO);

    /**
     * 获得{功能}列表
     *
     * @return {功能}列表
     */
    List<{功能}DO> get{功能}List();

}
```

#### 服务实现

**文件位置**: `service/{功能}/impl/{功能}ServiceImpl.java`

```java
package cn.iocoder.yudao.module.{业务名}.service.{功能};

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.{业务名}.controller.admin.{功能}.vo.{功能}PageReqVO;
import cn.iocoder.yudao.module.{业务名}.controller.admin.{功能}.vo.{功能}SaveReqVO;
import cn.iocoder.yudao.module.{业务名}.convert.{功能}Convert;
import cn.iocoder.yudao.module.{业务名}.dal.dataobject.{功能}.{功能}DO;
import cn.iocoder.yudao.module.{业务名}.dal.mysql.{功能}.{功能}Mapper;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.validation.annotation.Validated;

import static cn.iocoder.yudao.framework.common.exception.util.ServiceExceptionUtil.exception;
import static cn.iocoder.yudao.module.{业务名}.enums.ErrorCodeConstants.*;

/**
 * {功能} Service 实现类
 *
 * @author {作者名}
 */
@Service
@Validated
public class {功能}ServiceImpl implements {功能}Service {

    @Resource
    private {功能}Mapper {功能小驼峰}Mapper;

    @Override
    public Long create{功能}({功能}SaveReqVO createReqVO) {
        // 1. 校验数据
        validate{功能}ForCreateOrUpdate(null, createReqVO.getName(), createReqVO.getCode());

        // 2. 插入
        {功能}DO {功能小驼峰} = {功能}Convert.INSTANCE.convert(createReqVO);
        {功能小驼峰}Mapper.insert({功能小驼峰});
        return {功能小驼峰}.getId();
    }

    @Override
    public void update{功能}({功能}SaveReqVO updateReqVO) {
        // 1. 校验存在
        validate{功能}Exists(updateReqVO.getId());
        // 2. 校验数据
        validate{功能}ForCreateOrUpdate(updateReqVO.getId(), updateReqVO.getName(), updateReqVO.getCode());

        // 3. 更新
        {功能}DO updateObj = {功能}Convert.INSTANCE.convert(updateReqVO);
        {功能小驼峰}Mapper.updateById(updateObj);
    }

    @Override
    public void delete{功能}(Long id) {
        // 1. 校验存在
        validate{功能}Exists(id);

        // 2. 删除
        {功能小驼峰}Mapper.deleteById(id);
    }

    private void validate{功能}Exists(Long id) {
        if ({功能小驼峰}Mapper.selectById(id) == null) {
            throw exception({功能大写下划线}_NOT_EXISTS);
        }
    }

    private void validate{功能}ForCreateOrUpdate(Long id, String name, String code) {
        // 校验名称唯一
        // 校验编码唯一
        // ... 其他校验逻辑
    }

    @Override
    public {功能}DO get{功能}(Long id) {
        return {功能小驼峰}Mapper.selectById(id);
    }

    @Override
    public PageResult<{功能}DO> get{功能}Page({功能}PageReqVO pageReqVO) {
        return {功能小驼峰}Mapper.selectPage(pageReqVO);
    }

    @Override
    public List<{功能}DO> get{功能}List() {
        return {功能小驼峰}Mapper.selectList();
    }

}
```

### 4.4 Controller（控制层）

**文件位置**: `controller/admin/{功能}/{功能}Controller.java`

```java
package cn.iocoder.yudao.module.{业务名}.controller.admin.{功能};

import cn.iocoder.yudao.framework.common.pojo.CommonResult;
import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.{业务名}.controller.admin.{功能}.vo.*;
import cn.iocoder.yudao.module.{业务名}.convert.{功能}Convert;
import cn.iocoder.yudao.module.{业务名}.dal.dataobject.{功能}.{功能}DO;
import cn.iocoder.yudao.module.{业务名}.service.{功能}.{功能}Service;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import static cn.iocoder.yudao.framework.common.pojo.CommonResult.success;

/**
 * 管理后台 - {功能}
 *
 * @author {作者名}
 */
@Tag(name = "管理后台 - {功能}")
@RestController
@RequestMapping("/{业务名}/{功能小驼峰}")
@Validated
public class {功能}Controller {

    @Resource
    private {功能}Service {功能小驼峰}Service;

    @PostMapping("/create")
    @Operation(summary = "创建{功能}")
    @PreAuthorize("@ss.hasPermission('{业务名}:{功能小驼峰}:create')")
    public CommonResult<Long> create{功能}(@Valid @RequestBody {功能}SaveReqVO createReqVO) {
        return success({功能小驼峰}Service.create{功能}(createReqVO));
    }

    @PutMapping("/update")
    @Operation(summary = "更新{功能}")
    @PreAuthorize("@ss.hasPermission('{业务名}:{功能小驼峰}:update')")
    public CommonResult<Boolean> update{功能}(@Valid @RequestBody {功能}SaveReqVO updateReqVO) {
        {功能小驼峰}Service.update{功能}(updateReqVO);
        return success(true);
    }

    @DeleteMapping("/delete")
    @Operation(summary = "删除{功能}")
    @Parameter(name = "id", description = "编号", required = true, example = "1024")
    @PreAuthorize("@ss.hasPermission('{业务名}:{功能小驼峰}:delete')")
    public CommonResult<Boolean> delete{功能}(@RequestParam("id") Long id) {
        {功能小驼峰}Service.delete{功能}(id);
        return success(true);
    }

    @GetMapping("/get")
    @Operation(summary = "获得{功能}")
    @Parameter(name = "id", description = "编号", required = true, example = "1024")
    @PreAuthorize("@ss.hasPermission('{业务名}:{功能小驼曲}:query')")
    public CommonResult<{功能}RespVO> get{功能}(@RequestParam("id") Long id) {
        {功能}DO {功能小驼峰} = {功能小驼峰}Service.get{功能}(id);
        return success({功能}Convert.INSTANCE.convert({功能小驼峰}));
    }

    @GetMapping("/page")
    @Operation(summary = "获得{功能}分页")
    @PreAuthorize("@ss.hasPermission('{业务名}:{功能小驼峰}:query')")
    public CommonResult<PageResult<{功能}RespVO>> get{功能}Page(@Valid {功能}PageReqVO pageReqVO) {
        PageResult<{功能}DO> page = {功能小驼峰}Service.get{功能}Page(pageReqVO);
        return success({功能}Convert.INSTANCE.convertPage(page));
    }

    @GetMapping("/list")
    @Operation(summary = "获得{功能}列表")
    @PreAuthorize("@ss.hasPermission('{业务名}:{功能小驼峰}:query')")
    public CommonResult<List<{功能}RespVO>> get{功能}List() {
        List<{功能}DO> list = {功能小驼峰}Service.get{功能}List();
        return success({功能}Convert.INSTANCE.convertList(list));
    }

}
```

**关键点**：
- 使用 `@RestController` 和 `@RequestMapping`
- 使用 `@PreAuthorize` 控制权限
- 使用 `@Valid` 进行参数校验
- 统一返回 `CommonResult<T>`

### 4.5 VO（视图对象）

#### SaveReqVO（新增/编辑请求）

**文件位置**: `controller/admin/{功能}/vo/{功能}SaveReqVO.java`

```java
package cn.iocoder.yudao.module.{业务名}.controller.admin.{功能}.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.*;
import lombok.Data;

/**
 * {功能}新增/修改 Request VO
 *
 * @author {作者名}
 */
@Schema(description = "管理后台 - {功能}新增/修改 Request VO")
@Data
public class {功能}SaveReqVO {

    @Schema(description = "编号", example = "1024")
    private Long id;

    @Schema(description = "名称", requiredMode = Schema.RequiredMode.REQUIRED, example = "张三")
    @NotEmpty(message = "名称不能为空")
    @Size(max = 100, message = "名称长度不能超过100个字符")
    private String name;

    @Schema(description = "编码", requiredMode = Schema.RequiredMode.REQUIRED, example = "TEST001")
    @NotEmpty(message = "编码不能为空")
    @Size(max = 50, message = "编码长度不能超过50个字符")
    private String code;

    @Schema(description = "状态", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
    @NotNull(message = "状态不能为空")
    private Integer status;

    @Schema(description = "备注", example = "这是备注信息")
    @Size(max = 500, message = "备注长度不能超过500个字符")
    private String remark;

}
```

#### PageReqVO（分页查询请求）

**文件位置**: `controller/admin/{功能}/vo/{功能}PageReqVO.java`

```java
package cn.iocoder.yudao.module.{业务名}.controller.admin.{功能}.vo;

import cn.iocoder.yudao.framework.common.pojo.PageParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;

import static cn.iocoder.yudao.framework.common.util.date.DateUtils.FORMAT_YEAR_MONTH_DAY_HOUR_MINUTE_SECOND;

/**
 * {功能}分页 Request VO
 *
 * @author {作者名}
 */
@Schema(description = "管理后台 - {功能}分页 Request VO")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true)
public class {功能}PageReqVO extends PageParam {

    @Schema(description = "名称", example = "张三")
    private String name;

    @Schema(description = "编码", example = "TEST001")
    private String code;

    @Schema(description = "状态", example = "1")
    private Integer status;

    @Schema(description = "创建时间")
    @DateTimeFormat(pattern = FORMAT_YEAR_MONTH_DAY_HOUR_MINUTE_SECOND)
    private LocalDateTime[] createTime;

}
```

#### RespVO（响应结果）

**文件位置**: `controller/admin/{功能}/vo/{功能}RespVO.java`

```java
package cn.iocoder.yudao.module.{业务名}.controller.admin.{功能}.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * {功能} Response VO
 *
 * @author {作者名}
 */
@Schema(description = "管理后台 - {功能} Response VO")
@Data
public class {功能}RespVO {

    @Schema(description = "编号", requiredMode = Schema.RequiredMode.REQUIRED, example = "1024")
    private Long id;

    @Schema(description = "名称", requiredMode = Schema.RequiredMode.REQUIRED, example = "张三")
    private String name;

    @Schema(description = "编码", requiredMode = Schema.RequiredMode.REQUIRED, example = "TEST001")
    private String code;

    @Schema(description = "状态", requiredMode = Schema.RequiredMode.REQUIRED, example = "1")
    private Integer status;

    @Schema(description = "备注", example = "这是备注信息")
    private String remark;

    @Schema(description = "创建时间", requiredMode = Schema.RequiredMode.REQUIRED)
    private LocalDateTime createTime;

}
```

#### SimpleRespVO（简单响应，用于下拉选择）

**文件位置**: `controller/admin/{功能}/vo/{功能}SimpleRespVO.java`

```java
package cn.iocoder.yudao.module.{业务名}.controller.admin.{功能}.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

/**
 * {功能} Simple Response VO
 *
 * @author {作者名}
 */
@Schema(description = "管理后台 - {功能} Simple Response VO")
@Data
public class {功能}SimpleRespVO {

    @Schema(description = "编号", requiredMode = Schema.RequiredMode.REQUIRED, example = "1024")
    private Long id;

    @Schema(description = "名称", requiredMode = Schema.RequiredMode.REQUIRED, example = "张三")
    private String name;

}
```

### 4.6 Convert（对象转换器）

**文件位置**: `convert/{功能}Convert.java`

```java
package cn.iocoder.yudao.module.{业务名}.convert;

import cn.iocoder.yudao.framework.common.pojo.PageResult;
import cn.iocoder.yudao.module.{业务名}.controller.admin.{功能}.vo.*;
import cn.iocoder.yudao.module.{业务名}.dal.dataobject.{功能}.{功能}DO;
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

import java.util.List;

/**
 * {功能} Convert
 *
 * @author {作者名}
 */
@Mapper
public interface {功能}Convert {

    {功能}Convert INSTANCE = Mappers.getMapper({功能}Convert.class);

    {功能}DO convert({功能}SaveReqVO bean);

    {功能}RespVO convert({功能}DO bean);

    List<{功能}RespVO> convertList(List<{功能}DO> list);

    PageResult<{功能}RespVO> convertPage(PageResult<{功能}DO> page);

}
```

### 4.7 ErrorCodeConstants（错误码常量）

**文件位置**: `enums/ErrorCodeConstants.java`

```java
package cn.iocoder.yudao.module.{业务名}.enums;

/**
 * {业务名} 错误码枚举
 * {业务名}系统，使用 1-050-000-000 段
 *
 * @author {作者名}
 */
public interface ErrorCodeConstants {

    // ========== {功能} 模块 1-050-001-000 ==========
    String {功能大写下划线}_NOT_EXISTS = "1-050-001-000";
    String {功能大写下划线}_NAME_EXISTS = "1-050-001-001";
    String {功能大写下划线}_CODE_EXISTS = "1-050-001-002";

}
```

---

## 五、注册模块到项目

### 5.1 在主 pom.xml 注册模块

编辑 `ruoyi-vue-pro-master-jdk17/pom.xml`，在 `<modules>` 中添加：

```xml
<modules>
    <!-- ... 其他模块 ... -->
    <module>yudao-module-{业务名}</module>
</modules>
```

### 5.2 在 yudao-server 引入模块

编辑 `yudao-server/pom.xml`，在 `<dependencies>` 中添加：

```xml
<dependencies>
    <!-- ... 其他依赖 ... -->

    <!-- {业务名}模块 -->
    <dependency>
        <groupId>cn.iocoder.boot</groupId>
        <artifactId>yudao-module-{业务名}</artifactId>
        <version>${revision}</version>
    </dependency>
</dependencies>
```

### 5.3 数据库表创建

在 `sql/mysql/` 下创建 `{业务名}.sql` 文件：

```sql
-- ----------------------------
-- {业务名} 模块表结构
-- ----------------------------

DROP TABLE IF EXISTS `{表名}`;
CREATE TABLE `{表名}` (
    `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `name` varchar(100) NOT NULL COMMENT '名称',
    `code` varchar(50) NOT NULL COMMENT '编码',
    `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态（1正常 0停用）',
    `remark` varchar(500) DEFAULT NULL COMMENT '备注',
    `creator` varchar(64) DEFAULT '' COMMENT '创建者',
    `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater` varchar(64) DEFAULT '' COMMENT '更新者',
    `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否删除',
    `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
    PRIMARY KEY (`id`) USING BTREE,
    UNIQUE KEY `uk_code` (`code`, `deleted`, `tenant_id`) COMMENT '编码唯一索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='{功能}表';
```

---

## 六、完整示例

### 示例：创建医疗设备（Device）管理功能

假设要创建一个 `yudao-module-medical` 模块，包含设备管理功能：

#### 6.1 模块路径

- **模块名**: `yudao-module-medical`
- **业务名**: `medical`
- **功能名**: `device`
- **包名**: `cn.iocoder.yudao.module.medical`
- **表名**: `medical_device`

#### 6.2 文件映射

| 类型 | 文件路径 |
|-----|---------|
| DO | `dal/dataobject/device/DeviceDO.java` |
| Mapper | `dal/mysql/device/DeviceMapper.java` |
| Service | `service/device/DeviceService.java` |
| ServiceImpl | `service/device/impl/DeviceServiceImpl.java` |
| Controller | `controller/admin/device/DeviceController.java` |
| SaveReqVO | `controller/admin/device/vo/DeviceSaveReqVO.java` |
| PageReqVO | `controller/admin/device/vo/DevicePageReqVO.java` |
| RespVO | `controller/admin/device/vo/DeviceRespVO.java` |
| Convert | `convert/DeviceConvert.java` |

#### 6.3 请求路径

```
POST   /admin-api/medical/device/create   # 创建设备
PUT    /admin-api/medical/device/update   # 更新设备
DELETE /admin-api/medical/device/delete   # 删除设备
GET    /admin-api/medical/device/get      # 获取设备详情
GET    /admin-api/medical/device/page     # 分页查询设备
GET    /admin-api/medical/device/list     # 获取设备列表
```

#### 6.4 权限标识

```
medical:device:create    # 创建权限
medical:device:update    # 更新权限
medical:device:delete    # 删除权限
medical:device:query     # 查询权限
```

---

## 七、开发检查清单

新增模块时，请确认以下检查项：

- [ ] 1. 模块 pom.xml 配置正确，依赖必要的框架模块
- [ ] 2. 在主 pom.xml 的 `<modules>` 中注册模块
- [ ] 3. 在 yudao-server/pom.xml 中引入模块依赖
- [ ] 4. DO 类继承了 `TenantBaseDO`
- [ ] 5. Mapper 继承了 `BaseMapperX<DO>`
- [ ] 6. Service 接口和实现类使用了正确的注解
- [ ] 7. Controller 使用了 `@RestController`、`@RequestMapping` 和 `@PreAuthorize`
- [ ] 8. 所有 VO 类使用了正确的校验注解（`@Valid`、`@NotNull` 等）
- [ ] 9. Convert 接口使用了 `@Mapper` 注解
- [ ] 10. 数据库表包含租户字段 `tenant_id`
- [ ] 11. 编译项目无错误：`mvn clean compile`
- [ ] 12. 启动应用成功，能访问 Swagger 接口文档

---

## 八、常见问题

### Q1: 如何调试模块是否正确加载？

启动应用后，检查日志中是否有以下信息：
```
RequestMappingHandlerMapping : Mapped "{[/admin-api/{业务名}/{功能}/create],methods=[POST]}"
```

访问 Swagger 文档：`http://localhost:48080/doc.html`

### Q2: 如何处理多租户？

确保：
1. DO 类继承 `TenantBaseDO`
2. 数据库表包含 `tenant_id` 字段
3. 不需要租户隔离的方法使用 `@TenantIgnore` 注解

### Q3: 如何添加模块间调用？

在被调用模块的 `api/` 包下创建 API 接口和实现，调用方通过注入 API 接口使用。

### Q4: 错误码如何分配？

每个模块分配一段错误码，格式为：`X-YYY-ZZZ-ZZZ`
- X: 系统（1=业务系统）
- YYY: 模块编号（如 050=medical）
- ZZZ-ZZZ: 具体错误

---

*本文档最后更新于 2026-01-28*
