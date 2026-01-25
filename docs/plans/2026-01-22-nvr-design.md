# NVR 功能设计

## 目标与范围
- 新增 NVR 管理能力，基于 ZLMediaKit（ZLM）进行设备发现、管理、配置、监控与拉流。
- 支持 ONVIF 设备发现与基础配置；RTSP-only 设备支持手工与批量导入。
- 前端提供完整管理与监控页面（节点、设备/通道/码流、扫描任务、监控看板、预览）。
- 不做告警；播放不做鉴权；不做 ZLM 容器生命周期管理。

## 关键决策
- 模块：新增 `yudao-module-nvr`（由 `yudao-module-nrv` 重命名）。
- 多租户：每租户仅允许 1 个启用的 ZLM 实例；自动注册冲突则拒绝并记录日志。
- 业务封装：后端 `service/biz` 作为业务入口，类名包含 `Biz`；前端不使用 `biz` 命名。
- 设备模型：设备 → 通道（物理）→ 码流（主/子）。
- 拉流：按需拉流，空闲 5 分钟停止；使用 `app=nvr` 与 `stream=设备编码_通道编码_主/子`。
- 监控：Hook + 定时采集，分钟级落库，保留 7 天；流指标仅活跃或白名单采集。
- 播放：HLS；反代由独立 Nginx；每租户一个播放域名。

## 架构与模块
- `yudao-module-nvr` 依赖：`yudao-spring-boot-starter-web`、`security`、`mybatis`、`biz-tenant`、`biz-data-permission`。
- 分层：`controller/admin/**/vo`、`service/impl`、`service/biz`、`dal`、`convert`。
- 业务日志：`NvrBizOperateLogService` 通过 `OperateLogCommonApi` 记录关键动作。
- 字典：`NvrBizDictService` 通过 `DictDataApi` 提供设备类型/状态/码流类型等字典项。

## 数据模型（表前缀 nvr_）
- `nvr_media_node`：ZLM 节点（租户唯一），含地址、api/secret、hook_secret、播放域名、配置 JSON、配置版本、待重启标记、状态/心跳。
- `nvr_device`：设备（ONVIF/RTSP-only），含 onvif_uuid、IP/端口、账号密码（加密）、在线状态、来源。
- `nvr_channel`：物理通道（名称/编号/能力）。
- `nvr_stream`：码流（主/子）、rtsp_url、app/stream、拉流状态、最近拉流时间。
- `nvr_scan_task` / `nvr_scan_result`：扫描任务与结果（失败原因）。
- `nvr_metric_node_minute` / `nvr_metric_stream_minute`：监控分钟指标（保留 7 天）。
- 全部 DO 继承 `TenantBaseDO`；敏感字段使用 `EncryptTypeHandler`，VO 返回脱敏。

## 关键流程
1) ZLM 自动注册：ZLM 通过 Hook 上报 `tenantId+token`（Docker 环境变量注入），后端校验 hook.secret + IP 白名单，租户已有启用节点则拒绝并记录日志。  
2) 设备发现：管理员手动触发扫描（系统预填网段），先 WS-Discovery，再补 IP+端口探测；默认账号 + 设备级账号组合尝试；发现后生成通道与主/子码流。  
3) RTSP-only：手工/批量导入，生成通道与码流；在线状态为“未知”。  
4) 拉流：预览前触发 `addStreamProxy`，按需拉流；空闲 5 分钟停止；失败指数退避重试。  
5) 监控：Hook 驱动状态变化，定时调用 ZLM API 补偿一致性并落库。  
6) 配置下发：全量配置下发，若需重启标记“待重启”，由运维手工重启 ZLM。  

## API 与权限
- `controller/admin/nvr/**` 提供节点、设备/通道/码流、扫描任务、监控、拉流控制接口。
- 权限：`@PreAuthorize` + 数据权限默认开启，必要任务用 `@DataPermission(enable = false)`。
- 多租户：Hook/异步任务需设置租户上下文，确保数据落库正确。

## 前端页面
- 新增 NVR 菜单：节点管理、设备/通道/码流、扫描任务、监控看板、预览。
- 预览：调用后端拉流接口后生成 HLS 地址（反代域名 + `/nvr/{app}/{stream}/hls.m3u8`）。

## 运维与部署
- HLS 反代独立 Nginx，按租户域名配置 ZLM upstream。
- ZLM 生命周期仅登记与监控；不由后端直接创建/重启容器。

## 测试与验证
- 单元测试覆盖 `NvrBiz*Service` 关键流程（注册幂等、扫描、拉流、配置下发标记）。
- 集成验证：本地 ZLM + ONVIF 设备/模拟器，验证 Hook、拉流、监控落库链路。

## 后续扩展
- 诊室业务模块以“码流 ID”进行一对多绑定；一个设备/码流仅绑定一个诊室，避免权限冲突。
