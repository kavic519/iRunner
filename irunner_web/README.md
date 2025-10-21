## **项目概述**
这是一个基于 **Flutter** 开发的全平台跑步健身应用，集成了完整的用户系统、跑步追踪、社交功能和激励机制。

---

## **技术架构**

### **前端技术栈**
- **Flutter 3.0+**：跨平台UI框架（支持iOS、Android、Web、Desktop）
- **Provider**：全局状态管理
- **FlutterMap**：地图显示和路径绘制
- **Geolocator**：GPS定位服务
- **HTTP**：网络请求处理
- **SharedPreferences**：本地数据持久化

### **后端API架构**
- **RESTful API**：标准化接口设计
- **基础URL**：`http://www.kavic.xyz:8080/api`
- **响应格式**：统一JSON格式 `{success, message, data, error}`

---

## **核心功能实现**

### 1. **用户认证系统**
```dart
// 全局状态管理
class UserService extends ChangeNotifier {
  User? _currentUser;
  bool get isLoggedIn => _currentUser != null;
  // 登录状态全局同步
}
```

**实现功能：**

- 用户注册（用户名、密码、邮箱、昵称）
- 用户登录验证
- 安全退出登录
- 全局状态同步（登录状态在所有页面实时更新）
- 未登录引导（显示"请登录账号"提示）

**API接口：**

- `POST /api/users/register` - 用户注册
- `POST /api/users/login` - 用户登录  
- `GET /api/users/{userId}` - 获取用户信息

### 2. **跑步核心功能**
```dart
// 地图跑步页面
class MapPage extends StatefulWidget {
  // GPS追踪、实时地图显示、路径记录
}
```

**实现功能：**
- 实时GPS定位和地图显示
- 跑步轨迹实时绘制
- 时间、距离、速度实时计算
- 跑步数据本地存储和云端同步
- 跑步历史记录管理

**API接口：**
- `POST /api/runs/users/{userId}` - 创建跑步记录
- `GET /api/runs/users/{userId}` - 获取用户跑步记录
- `GET /api/runs/{runId}` - 获取跑步详情
- `DELETE /api/runs/{runId}` - 删除跑步记录

### 3. **用户个人中心**
```dart
// 响应式用户页面
@override
Widget build(BuildContext context) {
  return Consumer<UserService>(
    builder: (context, userService, child) {
      // 根据登录状态动态显示内容
    }
  );
}
```

**实现功能：**
- 个人资料展示（头像、昵称、统计数据）
- 跑步统计（总里程、总次数、总时长）
- 登录状态实时显示
- 账号管理（登录/注册/退出）

### 4. **社交圈子系统**
```dart
// 圈子管理页面
class CommunitiesPage extends StatefulWidget {
  // 创建、加入、退出、搜索圈子
}
```

**实现功能：**
- 创建和管理跑步圈子
- 加入/退出圈子功能
- 圈子搜索和发现
- 权限控制（创建者可删除圈子）
- 成员数量统计

**API接口：**
- `POST /api/communities` - 创建圈子
- `GET /api/communities` - 获取所有圈子
- `GET /api/communities/search` - 搜索圈子
- `POST /api/communities/{id}/join` - 加入圈子
- `POST /api/communities/{id}/leave` - 退出圈子

### 5. **排行榜系统**
```dart
// 排行榜页面
class LeaderboardPage extends StatefulWidget {
  // 多维度排名展示
}
```

**实现功能：**
- 全球跑步距离排行榜
- 跑步次数排行榜
- 实时数据更新
- 多维度排名切换

**API接口：**
- `GET /api/users/leaderboard?type=distance&limit=20` - 获取排行榜

### 6. **成就激励系统**
```dart
// 成就系统
class AchievementsPage extends StatefulWidget {
  // 成就展示和进度追踪
}
```

**实现功能：**
- 多类型成就解锁
- 成就进度实时追踪
- 激励机制设计
- 成就可视化展示

**API接口：**
- `GET /api/achievements/users/{userId}` - 获取用户成就

---

## **用户体验设计**

### **全局状态管理**
```dart
ChangeNotifierProvider(
  create: (_) => UserService(),
  child: MaterialApp(...)
)
```

### **响应式布局**
```dart
Column(
  mainAxisAlignment: MainAxisAlignment.start,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    const Spacer(flex: 1),
    // 内容区域
    const Spacer(flex: 2),
  ]
)
```

### **权限控制**
- 未登录：显示"请登录账号"引导
- 已登录：显示完整功能界面
- 创建者：拥有删除权限

---

## **数据流架构**

```
前端 Flutter App
      ↕ HTTP请求
后端 RESTful API (kavic.xyz:8080)
      ↕ 数据存储
    数据库系统
```

### **状态管理流程**
```
用户操作 → UserService → notifyListeners() → Consumer重建UI → 界面更新
```

---

## **项目亮点**

### **技术亮点**
1. **全平台支持**：一套代码运行在所有平台
2. **实时状态同步**：登录状态全局实时更新
3. **GPS集成**：精准的位置追踪和路径绘制
4. **模块化架构**：清晰的代码组织和可维护性
5. **错误处理**：完善的异常处理和用户提示

### **业务亮点**
1. **完整闭环**：从注册登录到跑步记录再到社交分享
2. **激励机制**：成就系统和排行榜提升用户粘性
3. **社交功能**：圈子系统促进用户互动
4. **用户体验**：直观的界面和流畅的交互

### **安全特性**
1. **用户认证**：安全的登录验证机制
2. **权限控制**：基于角色的功能访问控制
3. **数据验证**：前后端双重数据验证

### **应用价值**

- **移动应用开发**：Flutter跨平台开发能力
- **系统架构设计**：模块化、可扩展的架构
- **API集成**：RESTful接口设计和调用
- **状态管理**：复杂应用的状态管理方案
- **UI/UX设计**：现代化的用户界面设计
- **安全机制**：用户认证和权限控制

------

## 相关接口`API`

### 1.用户相关

| 方法 | 接口                     | 作用         |
| ---- | ------------------------ | ------------ |
| POST | `/api/users/register`    | 用户注册     |
| POST | `/api/users/login`       | 用户登录     |
| GET  | `/api/users/{userId}`    | 获取用户信息 |
| GET  | `/api/users/leaderboard` | 获取排行榜   |

#### 1.1用户注册：

- URL: `/api/users/register`

- 方法: POST

- ##### 请求体 (application/json):

```
{
  "username": "testuser4",
  "password": "123456",
  "email": "test4@example.com",
  "nickName": "用户4"
}
```

- ##### 成功响应 (200):

- ##### 1.1.1用户未注册

```
{
    "success": true,
    "message": "注册成功",
    "data": {
        "id": 4,
        "username": "testuser4",
        "email": "test4@example.com",
        "nickName": "用户4",
        "avatarUrl": "default_avatar.png",
        "totalRuns": 0,
        "totalDistance": 0.0,
        "totalDuration": 0,
        "createdAt": "2025-10-15T22:12:20.7364825"
    },
    "error": null
}
```

- ##### 1.1.2用户已注册

```
{
    "success": false,
    "message": "用户名已存在",
    "data": null,
    "error": null
}
```

#### 1.2用户登录：

- URL: `/api/users/login`

- 方法: POST

- ##### 请求体 (application/json):

```
{
  "username": "testuser4",
  "password": "123456"
}
```

- ##### 成功响应 (200):

- ##### 1.2.1用户和密码正确

```
{
    "success": true,
    "message": "登录成功",
    "data": {
        "id": 4,
        "username": "testuser4",
        "email": "test4@example.com",
        "nickName": "用户4",
        "avatarUrl": "default_avatar.png",
        "totalRuns": 0,
        "totalDistance": 0.0,
        "totalDuration": 0,
        "createdAt": "2025-10-15T22:12:20.736483"
    },
    "error": null
}
```

- ##### 1.2.2用户不正确

```
{
    "success": false,
    "message": "用户不存在",
    "data": null,
    "error": null
}
```

- ##### 1.2.3密码不正确

```
{
    "success": false,
    "message": "密码错误",
    "data": null,
    "error": null
}
```

#### 1.3 获取用户信息

- URL: `/api/users/{userId}`

- 方法: GET

- 路径参数: userId (用户ID)

- ##### 成功响应 (200):

- ##### 1.3.1用户ID`{userId}`存在

```
{
    "success": true,
    "message": "操作成功",
    "data": {
        "id": 4,
        "username": "testuser4",
        "email": "test4@example.com",
        "nickName": "用户4",
        "avatarUrl": "default_avatar.png",
        "totalRuns": 0,
        "totalDistance": 0.0,
        "totalDuration": 0,
        "createdAt": "2025-10-15T22:12:20.736483"
    },
    "error": null
}
```

- ##### 1.3.1用户ID`{userId}`不存在

```
{
    "success": false,
    "message": "用户不存在",
    "data": null,
    "error": null
}
```

#### 1.4 获取排行榜

- URL: `/api/users/leaderboard`

- 方法: GET

- 查询参数:

- - type (可选): 排序类型，可选值为 "distance"（按总距离）或 "runs"（按跑步次数），默认为 "distance"

- - limit (可选): 返回数量，例如 10

- ##### 成功响应 (200):

```
{
    "success": true,
    "message": "操作成功",
    "data": [
        {
            "id": 4,
            "username": "testuser4",
            "email": "test4@example.com",
            "nickName": "用户4",
            "avatarUrl": "default_avatar.png",
            "totalRuns": 1,
            "totalDistance": 4.0,
            "totalDuration": 0,
            "createdAt": "2025-10-15T22:12:20.736483"
        },
        {
            "id": 3,
            "username": "testuser",
            "email": "test@example.com",
            "nickName": "用户3",
            "avatarUrl": "default_avatar.png",
            "totalRuns": 2,
            "totalDistance": 3.0,
            "totalDuration": 0,
            "createdAt": "2025-10-15T21:51:04.195967"
        },
        {
            "id": 2,
            "username": "runner2",
            "email": "runner2@example.com",
            "nickName": "运动爱好者2",
            "avatarUrl": "default_avatar.png",
            "totalRuns": 3,
            "totalDistance": 2.0,
            "totalDuration": 0,
            "createdAt": "2025-10-15T21:42:58.775929"
        },
        {
            "id": 1,
            "username": "runner1",
            "email": "runner1@example.com",
            "nickName": "跑步爱好者1",
            "avatarUrl": "default_avatar.png",
            "totalRuns": 4,
            "totalDistance": 1.0,
            "totalDuration": 0,
            "createdAt": "2025-10-15T21:34:43.462365"
        }
    ],
    "error": null
}
```

------


### 2.跑步记录相关

| 方法 | 接口                              | 作用                   |
| ---- | --------------------------------- | ---------------------- |
| POST | `/api/runs/users/{userId}`        | 创建跑步记录           |
| GET  | `/api/runs/users/{userId}`        | 获取用户的所有跑步记录 |
| GET  | `/api/runs/users/{userId}/recent` | 获取用户的最近跑步记录 |
| GET  | `/api/runs/{runId}`               | 获取跑步记录详情       |
| GET  | `/api/runs/users/{userId}/stats`  | 获取用户统计信息       |

#### 2.1 创建跑步记录：

- URL: `/api/runs/users/{userId}`

- 方法: POST

- 路径参数: userId (用户ID)

- ##### 请求体 (application/json):

```
{
  "startTime": "2025-10-15T10:00:00",
  "endTime": "2025-10-15T10:30:00",
  "distanceMeters": 5000.0,
  "durationSeconds": 1800,
  "caloriesBurned": 300,
  "weatherCondition": "晴朗",
  "route": [
    {
      "latitude": 30.12345,
      "longitude": 120.12345,
      "order": 0
    },
    {
      "latitude": 30.12346,
      "longitude": 120.12346,
      "order": 1
    }
  ]
}
```

- ##### 成功响应 (200):

```
{
    "success": true,
    "message": "跑步记录创建成功",
    "data": {
        "id": 1,
        "userId": 1,
        "startTime": "2025-10-15T10:00:00",
        "endTime": "2025-10-15T10:30:00",
        "distanceMeters": 5000.0,
        "durationSeconds": 1800,
        "avgPace": 360.0,
        "caloriesBurned": 300,
        "weatherCondition": "晴朗",
        "createdAt": "2025-10-15T22:35:05.0584484",
        "route": [
            {
                "latitude": 30.12345,
                "longitude": 120.12345,
                "order": 0
            },
            {
                "latitude": 30.12346,
                "longitude": 120.12346,
                "order": 1
            }
        ]
    },
    "error": null
}
```

#### 2.2 获取用户的所有跑步记录

- URL: `/api/runs/users/{userId}`

- 方法: GET

- 路径参数: userId (用户ID)

- 查询参数:

- - limit (可选): 限制返回的记录数，例如 5

- ##### 成功响应 (200):

```
{
    "success": true,
    "message": "操作成功",
    "data": [
        {
            "id": 3,
            "userId": 2,
            "startTime": "2025-10-15T10:00:00",
            "endTime": "2025-10-15T10:30:00",
            "distanceMeters": 5000.0,
            "durationSeconds": 1800,
            "avgPace": 360.0,
            "caloriesBurned": 300,
            "weatherCondition": "晴朗",
            "createdAt": "2025-10-15T22:45:36.723862",
            "route": [
                {
                    "latitude": 30.12345,
                    "longitude": 120.12345,
                    "order": 0
                },
                {
                    "latitude": 30.12346,
                    "longitude": 120.12346,
                    "order": 1
                }
            ]
        }
		
	   // ... 其他跑步记录
    ],
    "error": null
}
```

#### 2.3 获取用户的最近跑步记录

- URL: `/api/runs/users/{userId}/recent`

- 方法: GET

- 路径参数: userId (用户ID)

- 查询参数:

- - limit (可选): 返回数量，默认为 5

- ##### 成功响应 (200):

```
{
    "success": true,
    "message": "操作成功",
    "data": [
        {
            "id": 3,
            "userId": 2,
            "startTime": "2025-10-15T10:00:00",
            "endTime": "2025-10-15T10:30:00",
            "distanceMeters": 5000.0,
            "durationSeconds": 1800,
            "avgPace": 360.0,
            "caloriesBurned": 300,
            "weatherCondition": "晴朗",
            "createdAt": "2025-10-15T22:45:36.723862",
            "route": [
                {
                    "latitude": 30.12345,
                    "longitude": 120.12345,
                    "order": 0
                },
                {
                    "latitude": 30.12346,
                    "longitude": 120.12346,
                    "order": 1
                }
            ]
        }
		// ... 其他跑步记录（最多 limit 条）
    ],
    "error": null
}
```

#### 2.4 获取跑步记录详情

- URL: `/api/runs/{runId}`

- 方法: GET

- 路径参数: runId (跑步记录ID)

- ##### 成功响应 (200):

```
{
    "success": true,
    "message": "操作成功",
    "data": {
        "id": 1,
        "userId": 1,
        "startTime": "2025-10-15T10:00:00",
        "endTime": "2025-10-15T10:30:00",
        "distanceMeters": 5000.0,
        "durationSeconds": 1800,
        "avgPace": 360.0,
        "caloriesBurned": 300,
        "weatherCondition": "晴朗",
        "createdAt": "2025-10-15T22:35:05.058448",
        "route": [
            {
                "latitude": 30.12345,
                "longitude": 120.12345,
                "order": 0
            },
            {
                "latitude": 30.12346,
                "longitude": 120.12346,
                "order": 1
            }
        ]
    },
    "error": null
}
```

#### 2.5 获取用户统计信息

- URL: `/api/runs/users/{userId}/stats`

- 方法: GET

- 路径参数: userId (用户ID)

- ##### 成功响应 (200):

```
{
    "success": true,
    "message": "操作成功",
    "data": {
        "totalRuns": 2,
        "totalDistance": 10000.0,
        "totalDuration": 3600
    },
    "error": null
}
```

------

### 3.圈子相关

| 方法 | 接口                                   | 作用               |
| ---- | -------------------------------------- | ------------------ |
| POST | `/api/communities`                     | 创建社区圈子       |
| GET  | `/api/communities`                     | 获取所有公开圈子   |
| GET  | `/api/communities/search`              | 搜索圈子           |
| GET  | `/api/communities/{communityId}`       | 获取圈子详情       |
| POST | `/api/communities/{communityId}/join`  | 用户加入圈子       |
| POST | `/api/communities/{communityId}/leave` | 用户退出圈子       |
| GET  | `/api/communities/users/{userId}`      | 获取用户加入的圈子 |

#### 3.1 创建社区圈子

- URL: `/api/communities?creatorId={id}`

- 方法: POST

- 查询参数: creatorId (创建者用户ID)

- ##### 请求体 (application/json):

```
{
  "name": "晨跑爱好者",
  "description": "每天清晨，一起迎接第一缕阳光",
  "imageUrl": "morning_runners.jpg",
  "isPublic": true
}
```

#### 3.2 获取所有公开圈子

- URL: `/api/communities`

- 方法: GET

- 查询参数:

- userId (可选): 当前用户ID，用于判断是否已加入

- ##### 成功响应 (200):

```
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "晨跑爱好者",
      "description": "每天清晨，一起迎接第一缕阳光",
      "imageUrl": "morning_runners.jpg",
      "memberCount": 10,
      "createdBy": 1,
      "createdAt": "2025-10-15T17:53:42.977",
      "isPublic": true,
      "isJoined": true   //BUG待修复：isJoined未识别
    },
    // ... 其他圈子
  ]
}
```

#### 3.3 搜索圈子

- URL: `/api/communities/search`

- 方法: GET

- 查询参数:

- keyword: 搜索关键词

- userId (可选): 当前用户ID，用于判断是否已加入

- ##### 成功响应 (200):

```
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "晨跑爱好者",
      "description": "每天清晨，一起迎接第一缕阳光",
      "imageUrl": "morning_runners.jpg",
      "memberCount": 10,
      "createdBy": 1,
      "createdAt": "2025-10-15T17:53:42.977",
      "isPublic": true,
      "isJoined": true
    },
    // ... 其他匹配的圈子
  ],
  "error": null
}
```

#### 3.4 获取圈子详情

- URL: `/api/communities/{communityId}`

- 方法: GET

- 路径参数: communityId (圈子ID)

- 查询参数:

- userId (可选): 当前用户ID，用于判断是否已加入

- ##### 成功响应 (200):

```
{
    "success": true,
    "message": "操作成功",
    "data": {
        "id": 2,
        "name": "晨跑爱好者",
        "description": "每天清晨，一起迎接第一缕阳光",
        "imageUrl": "default_community.jpg",
        "memberCount": 1,
        "createdBy": 1,
        "createdAt": "2025-10-16T00:23:35.732707",
        "isPublic": true,
        "isJoined": false
    },
    "error": null
}
```

#### 3.5 用户加入圈子

- URL: `/api/communities/{communityId}/join?userId={id}`

- 方法: POST

- 路径参数: communityId (圈子ID)

- 查询参数: userId (用户ID)

- ##### 成功响应 (200):

```
{
    "success": true,
    "message": "加入圈子成功",
    "data": null,
    "error": null
}
```

#### 3.6 用户退出圈子

- URL: `/api/communities/{communityId}/leave?userId={id}`

- 方法: POST

- 路径参数: communityId (圈子ID)

- 查询参数: userId (用户ID)

- ##### 成功响应 (200):

```
{
    "success": true,
    "message": "退出圈子成功",
    "data": null,
    "error": null
}
```

#### 3.7 获取用户加入的圈子

- URL: `/api/communities/users/{userId}`

- 方法: GET

- 路径参数: userId (用户ID)

- ##### 成功响应 (200):

```
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "晨跑爱好者",
      "description": "每天清晨，一起迎接第一缕阳光",
      "imageUrl": "morning_runners.jpg",
      "memberCount": 10,
      "createdBy": 1,
      "createdAt": "2025-10-15T17:53:42.977",
      "isPublic": true,
      "isJoined": true
    },
    // ... 其他已加入的圈子
  ],
  "error": null
}
```

------

### 4.成就相关

| 方法 | 接口                               | 作用               |
| ---- | ---------------------------------- | ------------------ |
| GET  | `/api/achievements/users/{userId}` | 获取用户的所有成就 |


#### 4.1 获取用户的所有成就

- URL: `/api/achievements/users/{userId}`

- 方法: GET

- 路径参数: userId (用户ID)

- ##### 成功响应 (200):

```
{
  "success": true,
  "data": [
    {
      "id": 1,
      "code": "first_run",
      "name": "初次征程",
      "description": "完成你的第一次跑步",
      "iconUrl": null,
      "conditionType": "TOTAL_RUNS",
      "conditionValue": 1.0,
      "isUnlocked": true,
      "progress": 1.0,
      "unlockedAt": "2025-10-15T17:53:42.977"
    },
    {
      "id": 2,
      "code": "one_kilometer",
      "name": "一公里跑者",
      "description": "单次跑步距离超过 1 公里",
      "iconUrl": null,
      "conditionType": "SINGLE_DISTANCE",
      "conditionValue": 1000.0,
      "isUnlocked": false,
      "progress": 500.0,
      "unlockedAt": null
    }
    // ... 其他成就
  ]
}
```



