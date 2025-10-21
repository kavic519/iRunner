# 接口`API`

## 1.用户相关

|方法|接口|作用|
|-|-|-|
|POST|`/api/users/register`|用户注册|
|POST|`/api/users/login`|用户登录|
|GET|`/api/users/{userId}`|获取用户信息|
|GET|`/api/users/leaderboard`|获取排行榜|

### 1.1用户注册：
- URL: `/api/users/register`

- 方法: POST

- #### 请求体 (application/json):
```
{
  "username": "testuser4",
  "password": "123456",
  "email": "test4@example.com",
  "nickName": "用户4"
}
```
- #### 成功响应 (200):
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

### 1.2用户登录：
- URL: `/api/users/login`

- 方法: POST

- #### 请求体 (application/json):
```
{
  "username": "testuser4",
  "password": "123456"
}
```
- #### 成功响应 (200):
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

### 1.3 获取用户信息
- URL: `/api/users/{userId}`

- 方法: GET

- 路径参数: userId (用户ID)

- #### 成功响应 (200):
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

### 1.4 获取排行榜
- URL: `/api/users/leaderboard`

- 方法: GET

- 查询参数:

- - type (可选): 排序类型，可选值为 "distance"（按总距离）或 "runs"（按跑步次数），默认为 "distance"

- - limit (可选): 返回数量，例如 10

- #### 成功响应 (200):
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




## 2.跑步记录相关

|方法|接口|作用|
|-|-|-|
|POST|`/api/runs/users/{userId}`|创建跑步记录|
|GET|`/api/runs/users/{userId}`|获取用户的所有跑步记录|
|GET|`/api/runs/users/{userId}/recent`|获取用户的最近跑步记录|
|GET|`/api/runs/{runId}`|获取跑步记录详情|
|DELETE|`/api/runs/{runId}`|删除跑步记录|
|GET|`/api/runs/users/{userId}/stats`|获取用户统计信息|

### 2.1 创建跑步记录：
- URL: `/api/runs/users/{userId}`

- 方法: POST

- 路径参数: userId (用户ID)

- #### 请求体 (application/json):
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
- #### 成功响应 (200):
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

### 2.2 获取用户的所有跑步记录
- URL: `/api/runs/users/{userId}`

- 方法: GET

- 路径参数: userId (用户ID)

- 查询参数:

- - limit (可选): 限制返回的记录数，例如 5

- #### 成功响应 (200):
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

### 2.3 获取用户的最近跑步记录
- URL: `/api/runs/users/{userId}/recent`

- 方法: GET

- 路径参数: userId (用户ID)

- 查询参数:

- - limit (可选): 返回数量，默认为 5

- #### 成功响应 (200):
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

### 2.4 获取跑步记录详情
- URL: `/api/runs/{runId}`

- 方法: GET

- 路径参数: runId (跑步记录ID)

- #### 成功响应 (200):
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

### 2.5 删除跑步记录
- URL: `/api/runs/{runId}`

- 方法: DELETE

- 路径参数: runId (跑步记录ID)

- #### 成功响应 (200):
```
{
    "success": true,
    "message": "跑步记录删除成功",
    "data": null,
    "error": null
}
```

### 2.6 获取用户统计信息
- URL: `/api/runs/users/{userId}/stats`

- 方法: GET

- 路径参数: userId (用户ID)

- #### 成功响应 (200):
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

## 3.圈子相关

|方法|接口|作用|
|-|-|-|
|POST|`/api/communities`|创建社区圈子|
|GET|`/api/communities`|获取所有公开圈子|
|GET|`/api/communities/search`|搜索圈子|
|GET|`/api/communities/{communityId}`|获取圈子详情|
|POST|`/api/communities/{communityId}/join`|用户加入圈子|
|POST|`/api/communities/{communityId}/leave`|用户退出圈子|
|GET|`/api/communities/users/{userId}`|获取用户加入的圈子|

### 3.1 创建社区圈子
- URL: `/api/communities?creatorId={id}`

- 方法: POST

- 查询参数: creatorId (创建者用户ID)

- #### 请求体 (application/json):
```
{
  "name": "晨跑爱好者",
  "description": "每天清晨，一起迎接第一缕阳光",
  "imageUrl": "morning_runners.jpg",
  "isPublic": true
}
```

### 3.2 获取所有公开圈子
- URL: `/api/communities`

- 方法: GET

- 查询参数:

- userId (可选): 当前用户ID，用于判断是否已加入

- #### 成功响应 (200):
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

### 3.3 搜索圈子
- URL: `/api/communities/search`

- 方法: GET

- 查询参数:

- keyword: 搜索关键词

- userId (可选): 当前用户ID，用于判断是否已加入

- #### 成功响应 (200):
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

### 3.4 获取圈子详情
- URL: `/api/communities/{communityId}`

- 方法: GET

- 路径参数: communityId (圈子ID)

- 查询参数:

- userId (可选): 当前用户ID，用于判断是否已加入

- #### 成功响应 (200):
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

### 3.5 用户加入圈子
- URL: `/api/communities/{communityId}/join?userId={id}`

- 方法: POST

- 路径参数: communityId (圈子ID)

- 查询参数: userId (用户ID)

- #### 成功响应 (200):
```
{
    "success": true,
    "message": "加入圈子成功",
    "data": null,
    "error": null
}
```

### 3.6 用户退出圈子
- URL: `/api/communities/{communityId}/leave?userId={id}`

- 方法: POST

- 路径参数: communityId (圈子ID)

- 查询参数: userId (用户ID)

- #### 成功响应 (200):
```
{
    "success": true,
    "message": "退出圈子成功",
    "data": null,
    "error": null
}
```

### 3.7 获取用户加入的圈子
- URL: `/api/communities/users/{userId}`

- 方法: GET

- 路径参数: userId (用户ID)

- #### 成功响应 (200):
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

## 4.成就相关
|方法|接口|作用|
|-|-|-|
|GET|`/api/achievements/users/{userId}`|获取用户的所有成就|


### 4.1 获取用户的所有成就
- URL: `/api/achievements/users/{userId}`

- 方法: GET

- 路径参数: userId (用户ID)

- #### 成功响应 (200):
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




