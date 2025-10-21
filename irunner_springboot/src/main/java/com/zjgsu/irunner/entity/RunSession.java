package com.zjgsu.irunner.entity;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "run_sessions")
public class RunSession {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    // 添加基本类型ID字段用于MyBatis
    @Column(name = "user_id")
    private Long userId;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", insertable = false, updatable = false)
    private User user;
    @Column(name = "start_time", nullable = false)
    private LocalDateTime startTime;
    @Column(name = "end_time")
    private LocalDateTime endTime;
    @Column(name = "distance_meters", nullable = false)
    private Double distanceMeters;                       // 距离(米)
    @Column(name = "duration_seconds", nullable = false)
    private Integer durationSeconds;                     // 时长(秒)
    @Column(name = "avg_pace")
    private Double avgPace;                              // 平均配速
    @Column(name = "calories_burned")
    private Integer caloriesBurned;                      // 卡路里
    @Column(name = "weather_condition")
    private String weatherCondition;                     // 天气状况
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    @OneToMany(mappedBy = "runSession", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @OrderBy("order ASC")
    private List<Coordinate> route = new ArrayList<>();  // 轨迹坐标

    // 构造函数
    public RunSession() {
        this.createdAt = LocalDateTime.now();
    }

    public RunSession(User user, LocalDateTime startTime, Double distanceMeters, Integer durationSeconds) {
        this();
        this.user = user;
        this.userId = user != null ? user.getId() : null;
        this.startTime = startTime;
        this.distanceMeters = distanceMeters;
        this.durationSeconds = durationSeconds;
        this.calculateAvgPace();
    }

    // 计算平均配速（秒/公里）
    public void calculateAvgPace() {
        if (distanceMeters != null && distanceMeters > 0 && durationSeconds != null) {
            this.avgPace = durationSeconds / (distanceMeters / 1000);
        }
    }

    // Getter 和 Setter 方法
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public User getUser() { return user; }
    public void setUser(User user) {
        this.user = user;
        if (user != null) {
            this.userId = user.getId();
        }
    }

    public LocalDateTime getStartTime() { return startTime; }
    public void setStartTime(LocalDateTime startTime) { this.startTime = startTime; }

    public LocalDateTime getEndTime() { return endTime; }
    public void setEndTime(LocalDateTime endTime) { this.endTime = endTime; }

    public Double getDistanceMeters() { return distanceMeters; }
    public void setDistanceMeters(Double distanceMeters) {
        this.distanceMeters = distanceMeters;
        this.calculateAvgPace();
    }

    public Integer getDurationSeconds() { return durationSeconds; }
    public void setDurationSeconds(Integer durationSeconds) {
        this.durationSeconds = durationSeconds;
        this.calculateAvgPace();
    }

    public Double getAvgPace() { return avgPace; }
    public void setAvgPace(Double avgPace) { this.avgPace = avgPace; }

    public Integer getCaloriesBurned() { return caloriesBurned; }
    public void setCaloriesBurned(Integer caloriesBurned) { this.caloriesBurned = caloriesBurned; }

    public String getWeatherCondition() { return weatherCondition; }
    public void setWeatherCondition(String weatherCondition) { this.weatherCondition = weatherCondition; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public List<Coordinate> getRoute() { return route; }
    public void setRoute(List<Coordinate> route) { this.route = route; }

    // 添加坐标点
    public void addCoordinate(Coordinate coordinate) {
        coordinate.setRunSession(this);
        this.route.add(coordinate);
    }
}