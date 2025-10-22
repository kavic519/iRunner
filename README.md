# iRunner 跑步健身应用

## 项目概述
iRunner 是一个基于 **Flutter** 开发的全平台跑步健身应用。项目集成了用户系统、跑步追踪、社交圈子、成就激励等功能模块，前后端通过 RESTful API 实现数据交互。
前端说明文档:[前端](https://github.com/kavic519/iRunner/blob/main/irunner_web/README.md)
后端说明文档:[后端](https://github.com/kavic519/iRunner/blob/main/irunner_springboot/README.md)

---

## 技术架构

### 前端技术栈
- **Flutter 3.0+**：跨平台 UI 框架
- **Provider**：全局状态管理
- **FlutterMap**：地图显示与路径绘制
- **Geolocator**：GPS 定位服务
- **HTTP**：网络请求处理
- **SharedPreferences**：本地数据持久化

### 后端 API 架构
- **RESTful API**：标准化接口设计
- **统一响应格式**：`{success, message, data, error}`
- **基础 URL**：`http://www.kavic.xyz:8080/api`

---

## 项目开发模式：增量与迭代

### 增量开发
- 项目采用**增量开发**模式，每次开发新增一个独立的功能模块或页面。
- 项目最初只有跑步页面，后续逐步**增量**增加了跑步记录页面、圈子页面、用户页面、主页面、成就页面等。
- 每个增量都通过 API 与后端数据联动，实现功能闭环。

### 迭代优化
- 对跑步页面进行多次界面美化、性能提升，对用户认证流程进行完善和异常处理，对圈子功能进行权限和交互优化。
- 迭代过程中持续修复 BUG，提升代码质量和稳定性。

---

## 主要功能模块

### 1. 用户认证系统
- 用户注册、登录、退出
- 全局登录状态同步，未登录时页面自动提示“请登录账号”
- 用户信息获取与展示

### 2. 跑步核心功能
- 实时 GPS 定位与地图轨迹绘制
- 跑步数据统计（距离、时间、速度等）
- 跑步记录创建、查询、详情展示

### 3. 用户个人中心
- 个人资料展示（头像、昵称、统计数据）
- 跑步统计（总里程、总次数、总时长）
- 账号管理（登录/注册/退出）

### 4. 社交圈子系统
- 创建、加入、退出圈子
- 圈子搜索与发现
- 权限控制（创建者可删除圈子）
- 成员数量统计

### 5. 排行榜系统
- 跑步距离、次数排行榜
- 多维度排名切换
- 实时数据更新

### 6. 成就激励系统
- 多类型成就解锁与进度追踪
- 成就可视化展示
- 激励机制设计

---

## 用户体验设计

- 全局状态管理：Provider 实现登录状态和数据同步
- 响应式布局：主要内容居中偏上，适配多端屏幕
- 权限控制：未登录时功能受限，已登录后解锁全部功能
- 友好交互：操作即时反馈，错误提示清晰

---

## 主要接口 API 示例

### 用户相关
- `POST /api/users/register`    用户注册
- `POST /api/users/login`       用户登录
- `GET /api/users/{userId}`     获取用户信息
- `GET /api/users/leaderboard`  获取排行榜

### 跑步记录相关
- `POST /api/runs/users/{userId}`        创建跑步记录
- `GET /api/runs/users/{userId}`         获取用户跑步记录
- `GET /api/runs/{runId}`                获取跑步详情
- `GET /api/runs/users/{userId}/stats`   获取用户统计信息

### 圈子相关
- `POST /api/communities`                     创建圈子
- `GET /api/communities`                      获取所有圈子
- `GET /api/communities/search`               搜索圈子
- `POST /api/communities/{communityId}/join`  加入圈子
- `POST /api/communities/{communityId}/leave` 退出圈子
- `GET /api/communities/users/{userId}`       获取用户加入的圈子

### 成就相关
- `GET /api/achievements/users/{userId}`      获取用户成就

---

## 数据流架构

```
Flutter App
   ↕ HTTP请求
RESTful API (kavic.xyz:8080)
   ↕ 数据存储
数据库系统
```

### 状态管理流程
```
用户操作 → UserService → notifyListeners() → Consumer重建UI → 界面更新
```

---

## 项目亮点

- **增量开发**：功能模块逐步扩展，项目从单一跑步页面发展为多功能健身应用
- **迭代优化**：持续完善已有功能，提升用户体验和系统稳定性
- **全平台支持**：一套代码多端运行
- **模块化架构**：代码结构清晰，易于维护和扩展
- **前后端联动**：API接口设计规范，数据交互高效

---

## 运行方式

- 基于 Flutter 环境，在 Android Studio 中运行
