package com.zjgsu.irunner.dto;

import java.time.LocalDateTime;
import java.util.List;

public class RunSessionResponse {

    private Long id;
    private Long userId;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private Double distanceMeters;
    private Integer durationSeconds;
    private Double avgPace;
    private Integer caloriesBurned;
    private String weatherCondition;
    private LocalDateTime createdAt;
    private List<CoordinateResponse> route;

    // 确保所有字段都有默认值或能处理null值
    public RunSessionResponse() {
        this.distanceMeters = 0.0;
        this.durationSeconds = 0;
        this.avgPace = 0.0;
        this.caloriesBurned = 0;
    }

    // Getter 和 Setter 方法
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public LocalDateTime getStartTime() { return startTime; }
    public void setStartTime(LocalDateTime startTime) { this.startTime = startTime; }

    public LocalDateTime getEndTime() { return endTime; }
    public void setEndTime(LocalDateTime endTime) { this.endTime = endTime; }

    public Double getDistanceMeters() { return distanceMeters; }
    public void setDistanceMeters(Double distanceMeters) {
        this.distanceMeters = distanceMeters != null ? distanceMeters : 0.0;
    }

    public Integer getDurationSeconds() { return durationSeconds; }
    public void setDurationSeconds(Integer durationSeconds) {
        this.durationSeconds = durationSeconds != null ? durationSeconds : 0;
    }

    public Double getAvgPace() { return avgPace; }
    public void setAvgPace(Double avgPace) {
        this.avgPace = avgPace != null ? avgPace : 0.0;
    }

    public Integer getCaloriesBurned() { return caloriesBurned; }
    public void setCaloriesBurned(Integer caloriesBurned) {
        this.caloriesBurned = caloriesBurned != null ? caloriesBurned : 0;
    }

    public String getWeatherCondition() { return weatherCondition; }
    public void setWeatherCondition(String weatherCondition) {
        this.weatherCondition = weatherCondition != null ? weatherCondition : "";
    }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public List<CoordinateResponse> getRoute() { return route; }
    public void setRoute(List<CoordinateResponse> route) {
        this.route = route != null ? route : java.util.Collections.emptyList();
    }
}