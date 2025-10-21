# iRunner 后端服务

基于 Spring Boot 的跑步社交应用后端服务

## 项目简介

iRunner 是一个现代化的跑步社交应用后端服务，为移动端提供完整的跑步数据追踪、用户社交和成就激励功能。项目采用 Spring Boot 框架，结合 MyBatis 和 JPA 双 ORM 架构，提供高性能、高可用的 RESTful API 服务。

### 核心功能

#### 跑步追踪模块
- GPS 轨迹记录：实时记录用户跑步轨迹坐标点
- 运动数据计算：自动计算距离、时长、配速、卡路里
- 批量数据处理：高性能的轨迹坐标批量存储
- 历史记录管理：完整的跑步记录 CRUD 操作

#### 用户管理模块
- 用户注册登录：安全的用户认证体系
- 个人信息管理：头像、昵称、个人统计管理
- 数据统计追踪：实时更新用户跑步总数据
- 排行榜系统：多维度用户排行榜（距离、次数、时长）

#### 社交圈子模块
- 社区创建管理：支持用户创建和管理跑步圈子
- 成员关系管理：完整的加入/退出机制
- 圈子搜索发现：关键词搜索和热门推荐
- 圈子计数操作：并发安全的成员数量管理

#### 成就激励模块
- **多维度成就系统**：基于跑步次数、距离、时长的成就体系
- **实时进度追踪**：自动检查和解锁用户成就
- **智能条件判断**：支持多种成就条件类型
- **进度可视化**：实时显示成就完成进度

## ★技术架构

### 后端技术栈
- **核心框架**：Spring Boot 3.x
- **数据持久化**：JPA/Hibernate + MyBatis（双ORM架构）
- **数据库**：MySQL 8.0
- API设计：RESTful风格
- **构建工具**：Maven

### 架构特色
- **分层架构**：清晰的 Controller-Service-Mapper-Entity 分层
- **统一响应**：标准化的 API 响应格式
- **全局异常**：统一的异常处理机制
- **事务管理**：声明式事务保障数据一致性
- **性能优化**：批量操作、懒加载、原子更新

# 系统要求

## 环境要求
- JDK 8 或更高版本  
- MySQL 5.7 或更高版本  
- Maven 3.6 或更高版本  

## 依赖服务
- MySQL 数据库服务  
- (可选) Redis 缓存服务（为后续扩展预留）  

---

## 快速开始

### 1. 数据库配置

```sql
CREATE DATABASE irunner CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
```

## 2. 配置文件

复制 application.properties 文件，配置数据库连接信息：

```properties
spring.datasource.url=jdbc:mysql://localhost:3060/irunner
spring.datasource.username=your_username
spring.datasource.password=your_password
```

## 3. 启动服务
```
mvn spring-boot:run
```
服务将在 `http://localhost:8080/api` 启动

## 数据库设计

### 核心数据表
- users - 用户信息表  
- run_sessions - 跑步记录表  
- coordinates - 轨迹坐标表  
- communities - 社区圈子表  
- achievements - 成就定义表  
- user_achievements - 用户成就关联表  
- user_community - 用户社区关系表  

### 关系设计
- 用户与跑步记录：一对多关系  
- 跑步记录与坐标点：一对多关系  
- 用户与社区圈子：多对多关系  
- 用户与成就系统：多对多关系（含进度状态）

## API 接口

API接口文档[API文档](https://github.com/kavic519/iRunner/blob/main/irunner_springboot/API.md)


## 项目特色

### 技术创新

- **双ORM架构**：JPA 简化基础 CRUD，MyBatis 优化复杂查询  
- **原子操作**：开发安全的统计更新机制  
- **批量处理**：高性能的轨迹坐标批量存储  
- **统一异常处理**：全局异常捕获和标准化错误响应  

### 业务价值

- **完整的功能闭环**：从数据采集到社交互动的完整业务流程  
- **可扩展架构**：模块化设计支持功能快速迭代  
- **性能优化**：针对运动应用场景的特殊优化  
- **数据一致性**：事务管理保障业务数据完整性  

### 扩展规划

#### 近期优化

- JWT 令牌认证增强安全性  
- **缓存机制提升性能**  
- API 限流防止滥用  
- **数据备份和恢复机制**

#### 长期规划
- 微服务架构改造

- 大数据分析平台

- 实时消息推送

- 第三方服务集成

