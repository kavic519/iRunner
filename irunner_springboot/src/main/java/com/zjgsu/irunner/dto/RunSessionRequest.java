package com.zjgsu.irunner.dto;

import java.time.LocalDateTime;
import java.util.List;

public class RunSessionRequest {

    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private Double distanceMeters;
    private Integer durationSeconds;
    private Integer caloriesBurned;
    private String weatherCondition;
    private List<CoordinateRequest> route;

    // 构造函数
    public RunSessionRequest() {}

    // Getter 和 Setter 方法
    public LocalDateTime getStartTime() { return startTime; }
    public void setStartTime(LocalDateTime startTime) { this.startTime = startTime; }

    public LocalDateTime getEndTime() { return endTime; }
    public void setEndTime(LocalDateTime endTime) { this.endTime = endTime; }

    public Double getDistanceMeters() { return distanceMeters; }
    public void setDistanceMeters(Double distanceMeters) { this.distanceMeters = distanceMeters; }

    public Integer getDurationSeconds() { return durationSeconds; }
    public void setDurationSeconds(Integer durationSeconds) { this.durationSeconds = durationSeconds; }

    public Integer getCaloriesBurned() { return caloriesBurned; }
    public void setCaloriesBurned(Integer caloriesBurned) { this.caloriesBurned = caloriesBurned; }

    public String getWeatherCondition() { return weatherCondition; }
    public void setWeatherCondition(String weatherCondition) { this.weatherCondition = weatherCondition; }

    public List<CoordinateRequest> getRoute() { return route; }
    public void setRoute(List<CoordinateRequest> route) { this.route = route; }
}